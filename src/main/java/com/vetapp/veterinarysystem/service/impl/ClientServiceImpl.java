package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.*;
import com.vetapp.veterinarysystem.model.*;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.repository.VaccinationRepository;
import com.vetapp.veterinarysystem.service.*;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ClientServiceImpl implements ClientService {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy");

    private final ClientRepository clientRepository;
    private final UserRepository userRepository;
    private final VaccinationRepository vaccinationRepository;
    private final ModelMapper modelMapper;
    private final LocalityService localityService;

    // Constructor, @RequiredArgsConstructor varsa manuel olarak yazmaya gerek yok.
    // Eğer Lombok'u kullanıyorsanız bu constructor'ı silebilirsiniz, Lombok sizin için oluşturacaktır.
    // Ancak, benim tarafımdan eklenen @Autowired PasswordEncoder gibi alanlar varsa,
    // Lombok ile çalışması için ya o da final olmalı ya da @AllArgsConstructor kullanılmalı.
    // Şimdilik sorunsuz çalışması için manuel constructor'ı koruyorum ve gerekli atamayı yapıyorum.
    public ClientServiceImpl(ClientRepository clientRepository,
                             UserRepository userRepository,
                             VaccinationRepository vaccinationRepository,
                             ModelMapper modelMapper,
                             LocalityService localityService) {
        this.clientRepository = clientRepository;
        this.userRepository = userRepository;
        this.vaccinationRepository = vaccinationRepository;
        this.modelMapper = modelMapper;
        this.localityService = localityService;
    }

    @Override
    @Transactional
    public ClientDto createClient(ClientDto clientDto) {
        User user = userRepository.findByUsername(clientDto.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found!"));

        Client client = new Client();
        client.setUser(user);
        client.setFirstName(clientDto.getFirstName());
        client.setLastName(clientDto.getLastName());

        // Yeni adres alanlarını set et
        if (clientDto.getLocalityCode() != null) {
            Locality locality = localityService.getLocalityByCode(clientDto.getLocalityCode())
                    .orElseThrow(() -> new IllegalArgumentException("Locality not found for code: " + clientDto.getLocalityCode()));
            client.setLocality(locality);
        } else { // Eğer localityCode null ise veya seçim yoksa locality'yi de null yap
            client.setLocality(null);
        }
        client.setStreetAddress(clientDto.getStreetAddress());
        client.setApartmentNumber(clientDto.getApartmentNumber());
        client.setPostalCode(clientDto.getPostalCode());

        Client savedClient = clientRepository.save(client);
        return convertToClientDto(savedClient);
    }

    @Override
    public ClientDto getClientById(Long id) {
        Client client = clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client not found!"));
        return convertToClientDto(client);
    }

    @Override
    public List<ClientDto> getAllClients() {
        return clientRepository.findAll().stream()
                .map(this::convertToClientDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public ClientDto updateClient(Long id, ClientDto clientDto) {
        Client client = clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client not found"));

        User user = userRepository.findByUsername(clientDto.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Hata aldığınız satırın düzeltilmiş hali: long değerleri == ile karşılaştırılır
        if (clientRepository.existsByUser(user) && client.getUser().getUserID() != user.getUserID()) {
            throw new IllegalStateException("This user is already assigned to another client.");
        }

        client.setFirstName(clientDto.getFirstName());
        client.setLastName(clientDto.getLastName());

        // Yeni adres alanlarını güncelle
        if (clientDto.getLocalityCode() != null) {
            Locality locality = localityService.getLocalityByCode(clientDto.getLocalityCode())
                    .orElseThrow(() -> new IllegalArgumentException("Locality not found for code: " + clientDto.getLocalityCode()));
            client.setLocality(locality);
        } else {
            client.setLocality(null);
        }
        client.setStreetAddress(clientDto.getStreetAddress());
        client.setApartmentNumber(clientDto.getApartmentNumber());
        client.setPostalCode(clientDto.getPostalCode());

        client.setUser(user);

        Client updated = clientRepository.save(client);
        return convertToClientDto(updated);
    }

    @Override
    public ClientDetailDto getClientDetailByUsername(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Client client = clientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Client not found"));

        List<PetInfoDto> petInfoList = client.getPets().stream().map(pet -> {
            PetInfoDto dto = new PetInfoDto();
            dto.setName(pet.getName());
            dto.setSpecies(pet.getSpecies().getSpeciesName());
            dto.setBreed(pet.getBreed().getBreedName());
            dto.setGender(pet.getGender().getGenderName());
            dto.setClinicName(pet.getClinic() != null ? pet.getClinic().getClinicName() : "Unknown");
            dto.setAge(pet.getAge());

            List<VaccinationDto> vaccinations = vaccinationRepository.findByPet(pet).stream()
                    .map(v -> {
                        VaccinationDto vaccDto = new VaccinationDto();
                        vaccDto.setVaccineName(v.getVaccineType().getVaccineName());
                        vaccDto.setDateAdministered(v.getDateAdministered() != null ? v.getDateAdministered().format(DATE_FORMATTER) : "N/A");
                        vaccDto.setNextDueDate(v.getNextDueDate() != null ? v.getNextDueDate().format(DATE_FORMATTER) : "N/A");
                        vaccDto.setUpcoming(v.getNextDueDate() != null && v.getNextDueDate().isAfter(LocalDate.now()));
                        return vaccDto;
                    })
                    .sorted(Comparator.comparing(VaccinationDto::isUpcoming).reversed()
                            .thenComparing(v -> {
                                if ("N/A".equals(v.getNextDueDate())) return LocalDate.MAX;
                                try {
                                    return LocalDate.parse(v.getNextDueDate(), DATE_FORMATTER);
                                } catch (java.time.format.DateTimeParseException e) {
                                    return LocalDate.MAX;
                                }
                            }))
                    .collect(Collectors.toList());
            dto.setVaccinations(vaccinations);

            List<MedicalRecordDto> medicalRecords = pet.getMedicalRecords().stream()
                    .map(mr -> {
                        MedicalRecordDto rec = new MedicalRecordDto();
                        rec.setDate(mr.getDate() != null ? mr.getDate().toString() : null);
                        rec.setDescription(mr.getDescription());
                        rec.setTreatment(mr.getTreatment());
                        return rec;
                    })
                    .collect(Collectors.toList());
            dto.setMedicalRecords(medicalRecords);

            return dto;
        }).collect(Collectors.toList());

        ClientDetailDto detail = new ClientDetailDto();
        detail.setFirstName(client.getFirstName());
        detail.setLastName(client.getLastName());
        detail.setAddress(formatClientAddress(client));
        detail.setPets(petInfoList);

        return detail;
    }

    @Override
    public List<PetInfoDto> getPetsOfClient(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Client client = clientRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Client not found"));

        return client.getPets().stream().map(pet -> {
            PetInfoDto dto = new PetInfoDto();
            dto.setId(pet.getPetID().intValue());
            dto.setName(pet.getName());
            dto.setSpecies(pet.getSpecies().getSpeciesName());
            dto.setBreed(pet.getBreed().getBreedName());
            dto.setGender(pet.getGender().getGenderName());
            dto.setClinicName(pet.getClinic() != null ? pet.getClinic().getClinicName() : "Unknown");
            dto.setAge(pet.getAge());

            List<VaccinationDto> vaccinations = vaccinationRepository.findByPet(pet).stream()
                    .map(v -> {
                        VaccinationDto vaccDto = new VaccinationDto();
                        vaccDto.setVaccineName(v.getVaccineType().getVaccineName());
                        vaccDto.setDateAdministered(v.getDateAdministered() != null ? v.getDateAdministered().format(DATE_FORMATTER) : "N/A");
                        vaccDto.setNextDueDate(v.getNextDueDate() != null ? v.getNextDueDate().format(DATE_FORMATTER) : "N/A");
                        vaccDto.setUpcoming(v.getNextDueDate() != null && v.getNextDueDate().isAfter(LocalDate.now()));
                        return vaccDto;
                    })
                    .sorted(Comparator.comparing(VaccinationDto::isUpcoming).reversed()
                            .thenComparing(v -> {
                                if ("N/A".equals(v.getNextDueDate())) return LocalDate.MAX;
                                try {
                                    return LocalDate.parse(v.getNextDueDate(), DATE_FORMATTER);
                                } catch (java.time.format.DateTimeParseException e) {
                                    return LocalDate.MAX;
                                }
                            }))
                    .collect(Collectors.toList());
            dto.setVaccinations(vaccinations);

            List<MedicalRecordDto> medicalRecords = pet.getMedicalRecords().stream()
                    .map(mr -> {
                        MedicalRecordDto rec = new MedicalRecordDto();
                        rec.setDate(mr.getDate() != null ? mr.getDate().toString() : null);
                        rec.setDescription(mr.getDescription());
                        rec.setTreatment(mr.getTreatment());
                        return rec;
                    })
                    .collect(Collectors.toList());
            dto.setMedicalRecords(medicalRecords);

            return dto;
        }).collect(Collectors.toList());
    }


    @Override
    public Client getClientByUsername(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return clientRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Client not found"));
    }

    @Override
    public ClientAccountSettingsDto getAccountSettings(String username) {
        Client client = clientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Client not found!"));
        ClientAccountSettingsDto dto = new ClientAccountSettingsDto();
        dto.setId(client.getClientId());
        dto.setFirstName(client.getFirstName());
        dto.setLastName(client.getLastName());
        dto.setEmail(client.getUser().getEmail());
        dto.setPhone(client.getUser().getPhone());
        // Yeni adres alanlarını DTO'ya aktar
        if (client.getLocality() != null) {
            dto.setLocalityCode(client.getLocality().getCode());
            // Eğer District ve City bilgileri de lazım ise eager fetch veya ayrı sorgu ile çekilmeli
            // Eğer Locality objesi içinde District ve City bilgileri yüklüyse, bunları da DTO'ya set edebiliriz:
            if (client.getLocality().getDistrict() != null) {
                dto.setDistrictCode(client.getLocality().getDistrict().getCode());
                if (client.getLocality().getDistrict().getCity() != null) {
                    dto.setCityCode(client.getLocality().getDistrict().getCity().getCode());
                }
            }
        }
        dto.setStreetAddress(client.getStreetAddress());
        dto.setApartmentNumber(client.getApartmentNumber());
        dto.setPostalCode(client.getPostalCode());
        return dto;
    }

    @Override
    @Transactional
    public void updateAccountSettings(String username, ClientAccountSettingsDto dto) {
        Client client = clientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Client not found!"));
        client.setFirstName(dto.getFirstName());
        client.setLastName(dto.getLastName());
        // User bilgilerini de güncelle
        User user = client.getUser();
        if (user != null) {
            user.setEmail(dto.getEmail());
            user.setPhone(dto.getPhone());
            userRepository.save(user); // User nesnesini de kaydetmeyi unutmayın
        }

        // Yeni adres alanlarını güncelle
        if (dto.getLocalityCode() != null) {
            Locality locality = localityService.getLocalityByCode(dto.getLocalityCode())
                    .orElseThrow(() -> new IllegalArgumentException("Locality not found for code: " + dto.getLocalityCode()));
            client.setLocality(locality);
        } else {
            client.setLocality(null);
        }
        client.setStreetAddress(dto.getStreetAddress());
        client.setApartmentNumber(dto.getApartmentNumber());
        client.setPostalCode(dto.getPostalCode());

        clientRepository.save(client);
    }

    @Autowired // PasswordEncoder'ı final yapmadığınız için @Autowired kullanmak zorundasınız.
    private PasswordEncoder passwordEncoder;

    @Override
    public boolean changePassword(String username, PasswordChangeDto dto) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!passwordEncoder.matches(dto.getOldPassword(), user.getPasswordHash())) {
            return false;
        }
        if (!dto.getNewPassword().equals(dto.getNewPasswordConfirm())) {
            return false;
        }
        user.setPasswordHash(passwordEncoder.encode(dto.getNewPassword()));
        userRepository.save(user);
        return true;
    }

    @Override
    public void deleteClient(Long id) {
        clientRepository.deleteById(id);
    }

    // Client nesnesini ClientDto'ya dönüştürmek için yardımcı metod
    private ClientDto convertToClientDto(Client client) {
        ClientDto dto = new ClientDto();
        dto.setClientId(client.getClientId());
        dto.setFirstName(client.getFirstName());
        dto.setLastName(client.getLastName());
        dto.setUsername(client.getUser() != null ? client.getUser().getUsername() : null);

        // Adres bilgilerini DTO'ya aktar
        if (client.getLocality() != null) {
            dto.setLocalityCode(client.getLocality().getCode());
            // Mahalle bağlı olduğu ilçeye, ilçe bağlı olduğu şehre erişebiliyorsa
            if (client.getLocality().getDistrict() != null) {
                dto.setDistrictCode(client.getLocality().getDistrict().getCode());
                if (client.getLocality().getDistrict().getCity() != null) {
                    dto.setCityCode(client.getLocality().getDistrict().getCity().getCode());
                }
            }
        }
        dto.setStreetAddress(client.getStreetAddress());
        dto.setApartmentNumber(client.getApartmentNumber());
        dto.setPostalCode(client.getPostalCode());
        return dto;
    }

    // Client adresini görüntülemek için formatlama metodu
    private String formatClientAddress(Client client) {
        StringBuilder addressBuilder = new StringBuilder();
        // Sokak ve daire numarası
        if (client.getStreetAddress() != null && !client.getStreetAddress().isEmpty()) {
            addressBuilder.append(client.getStreetAddress());
        }
        if (client.getApartmentNumber() != null && !client.getApartmentNumber().isEmpty()) {
            if (addressBuilder.length() > 0) addressBuilder.append(", ");
            addressBuilder.append("Daire: ").append(client.getApartmentNumber());
        }

        // Mahalle, ilçe, il
        if (client.getLocality() != null) {
            if (addressBuilder.length() > 0) addressBuilder.append(", ");
            addressBuilder.append(client.getLocality().getName());
            if (client.getLocality().getDistrict() != null) {
                addressBuilder.append(" / ").append(client.getLocality().getDistrict().getName());
                if (client.getLocality().getDistrict().getCity() != null) {
                    addressBuilder.append(" / ").append(client.getLocality().getDistrict().getCity().getName());
                }
            }
        }
        // Posta kodu
        if (client.getPostalCode() != null && !client.getPostalCode().isEmpty()) {
            if (addressBuilder.length() > 0) addressBuilder.append(" - ");
            addressBuilder.append(client.getPostalCode());
        }
        return addressBuilder.toString();
    }
}