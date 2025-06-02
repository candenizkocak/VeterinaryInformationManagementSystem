package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.*;
import com.vetapp.veterinarysystem.model.Client;
import com.vetapp.veterinarysystem.model.MedicalRecord;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.repository.VaccinationRepository;
import com.vetapp.veterinarysystem.service.ClientService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate; // Keep this import as you still use LocalDate in Java
import java.time.format.DateTimeFormatter; // Import DateTimeFormatter
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ClientServiceImpl implements ClientService {

    // Define a DateTimeFormatter for consistent date formatting
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy");

    private final ClientRepository clientRepository;
    private final UserRepository userRepository;
    private final VaccinationRepository vaccinationRepository;
    private final ModelMapper modelMapper;

    public ClientServiceImpl(ClientRepository clientRepository,
                             UserRepository userRepository,
                             VaccinationRepository vaccinationRepository,
                             ModelMapper modelMapper) {
        this.clientRepository = clientRepository;
        this.userRepository = userRepository;
        this.vaccinationRepository = vaccinationRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public ClientDto createClient(ClientDto clientDto) {
        User user = userRepository.findByUsername(clientDto.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found!"));

        Client client = modelMapper.map(clientDto, Client.class);
        client.setUser(user);

        Client savedClient = clientRepository.save(client);
        return modelMapper.map(savedClient, ClientDto.class);
    }

    @Override
    public ClientDto getClientById(Long id) {
        Client client = clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client not found!"));
        return modelMapper.map(client, ClientDto.class);
    }

    @Override
    public List<ClientDto> getAllClients() {
        return clientRepository.findAll().stream()
                .map(client -> modelMapper.map(client, ClientDto.class))
                .collect(Collectors.toList());
    }

    @Override
    public ClientDto updateClient(Long id, ClientDto clientDto) {
        Client client = clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client not found"));

        User user = userRepository.findByUsername(clientDto.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (clientRepository.existsByUser(user) && client.getUser().getUserID() != user.getUserID()) {
            throw new IllegalStateException("This user is already assigned to another client.");
        }

        client.setFirstName(clientDto.getFirstName());
        client.setLastName(clientDto.getLastName());
        client.setAddress(clientDto.getAddress());
        client.setUser(user);

        Client updated = clientRepository.save(client);
        return modelMapper.map(updated, ClientDto.class);
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

            // --- MODIFIED SECTION ---
            List<VaccinationDto> vaccinations = vaccinationRepository.findByPet(pet).stream()
                    .map(v -> {
                        VaccinationDto vaccDto = new VaccinationDto();
                        vaccDto.setVaccineName(v.getVaccineType().getVaccineName());
                        // Format LocalDate to String
                        vaccDto.setDateAdministered(v.getDateAdministered() != null ? v.getDateAdministered().format(DATE_FORMATTER) : "N/A");
                        vaccDto.setNextDueDate(v.getNextDueDate() != null ? v.getNextDueDate().format(DATE_FORMATTER) : "N/A");
                        // Calculate upcoming status
                        vaccDto.setUpcoming(v.getNextDueDate() != null && v.getNextDueDate().isAfter(LocalDate.now()));
                        return vaccDto;
                    })
                    // Optional: Sort vaccinations by nextDueDate to show upcoming ones first
                    .sorted(Comparator.comparing(VaccinationDto::isUpcoming).reversed() // true (upcoming) first
                            .thenComparing(v -> v.getNextDueDate().equals("N/A") ? LocalDate.MAX : LocalDate.parse(v.getNextDueDate(), DATE_FORMATTER))) // then by date
                    .collect(Collectors.toList());
            dto.setVaccinations(vaccinations);
            // --- END MODIFIED SECTION ---

            // Tedavi kayıtlarını MedicalRecordDto olarak alıyoruz
            List<MedicalRecordDto> medicalRecords = pet.getMedicalRecords().stream()
                    .map(mr -> modelMapper.map(mr, MedicalRecordDto.class))
                    .collect(Collectors.toList());
            dto.setMedicalRecords(medicalRecords);

            return dto;
        }).collect(Collectors.toList());

        ClientDetailDto detail = new ClientDetailDto();
        detail.setFirstName(client.getFirstName());
        detail.setLastName(client.getLastName());
        detail.setAddress(client.getAddress());
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

            // --- MODIFIED SECTION ---
            List<VaccinationDto> vaccinations = vaccinationRepository.findByPet(pet).stream()
                    .map(v -> {
                        VaccinationDto vaccDto = new VaccinationDto();
                        vaccDto.setVaccineName(v.getVaccineType().getVaccineName());
                        // Format LocalDate to String
                        vaccDto.setDateAdministered(v.getDateAdministered() != null ? v.getDateAdministered().format(DATE_FORMATTER) : "N/A");
                        vaccDto.setNextDueDate(v.getNextDueDate() != null ? v.getNextDueDate().format(DATE_FORMATTER) : "N/A");
                        // Calculate upcoming status
                        vaccDto.setUpcoming(v.getNextDueDate() != null && v.getNextDueDate().isAfter(LocalDate.now()));
                        return vaccDto;
                    })
                    // Optional: Sort vaccinations by nextDueDate to show upcoming ones first
                    .sorted(Comparator.comparing(VaccinationDto::isUpcoming).reversed() // true (upcoming) first
                            .thenComparing(v -> {
                                if (v.getNextDueDate().equals("N/A")) return LocalDate.MAX; // Treat N/A as very far future for sorting
                                try {
                                    return LocalDate.parse(v.getNextDueDate(), DATE_FORMATTER);
                                } catch (java.time.format.DateTimeParseException e) {
                                    // Handle parsing error if nextDueDate format is inconsistent
                                    return LocalDate.MAX;
                                }
                            }))
                    .collect(Collectors.toList());
            dto.setVaccinations(vaccinations);
            // --- END MODIFIED SECTION ---

            List<MedicalRecordDto> medicalRecords = pet.getMedicalRecords().stream()
                    .map(mr -> {
                        MedicalRecordDto rec = new MedicalRecordDto();
                        rec.setDate(mr.getDate() != null ? mr.getDate().toString() : null); // Keep as string or format if needed
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
        dto.setAddress(client.getAddress());
        return dto;
    }

    @Override
    public void updateAccountSettings(String username, ClientAccountSettingsDto dto) {
        Client client = clientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Client not found!"));
        client.setFirstName(dto.getFirstName());
        client.setLastName(dto.getLastName());
        client.getUser().setEmail(dto.getEmail());
        client.getUser().setPhone(dto.getPhone());
        client.setAddress(dto.getAddress());
        clientRepository.save(client);
    }


    @Autowired
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
    public void deleteClient(Long id) { // Implemented here
        clientRepository.deleteById(id);
    }

}