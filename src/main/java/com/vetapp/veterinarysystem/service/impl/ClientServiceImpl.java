package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.ClientDetailDto;
import com.vetapp.veterinarysystem.dto.ClientDto;
import com.vetapp.veterinarysystem.dto.MedicalRecordDto;
import com.vetapp.veterinarysystem.dto.PetInfoDto;
import com.vetapp.veterinarysystem.model.Client;
import com.vetapp.veterinarysystem.model.MedicalRecord;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.repository.VaccinationRepository;
import com.vetapp.veterinarysystem.service.ClientService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ClientServiceImpl implements ClientService {

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

            // Aşı isimlerini alıyoruz:
            List<String> vaccineNames = vaccinationRepository.findByPet(pet).stream()
                    .map(v -> v.getVaccineType().getVaccineName())
                    .distinct()
                    .collect(Collectors.toList());
            dto.setVaccineNames(vaccineNames);

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
            dto.setId(pet.getPetID().intValue()); //bu kısmı değiştirdim dto dan geleni dönüştürüyor bu sayede sadece burası için değişti
            dto.setName(pet.getName());
            dto.setSpecies(pet.getSpecies().getSpeciesName());
            dto.setBreed(pet.getBreed().getBreedName());
            dto.setGender(pet.getGender().getGenderName());
            dto.setClinicName(pet.getClinic() != null ? pet.getClinic().getClinicName() : "Unknown");
            dto.setAge(pet.getAge());

            List<String> vaccineNames = vaccinationRepository.findByPet(pet).stream()
                    .map(v -> v.getVaccineType().getVaccineName())
                    .distinct()
                    .collect(Collectors.toList());
            dto.setVaccineNames(vaccineNames);

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
    public void deleteClient(Long id) {
        clientRepository.deleteById(id);
    }
}
