package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.*;
import com.vetapp.veterinarysystem.repository.*;
import com.vetapp.veterinarysystem.service.MedicalRecordService;
import com.vetapp.veterinarysystem.service.PetService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.dao.DataIntegrityViolationException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService {

    private final PetRepository petRepository;
    private final ClinicRepository clinicRepository;
    private final ClientRepository clientRepository;
    private final SpeciesRepository speciesRepository;
    private final BreedRepository breedRepository;
    private final GenderRepository genderRepository;
    private final MedicalRecordRepository medicalRecordRepository;
    private final AppointmentRepository appointmentRepository;



    @Override
    @Transactional
    public void deletePet(int id) {
        Pet petToDelete = petRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pet not found with ID: " + id));


        if (appointmentRepository.existsByPet_PetID(id)) {

            throw new DataIntegrityViolationException("This pet has existing appointments and cannot be deleted. Please cancel or reassign appointments first.");
        }

        petRepository.deleteById(id);
    }

    @Override
    @Transactional
    public void deletePetById(int id) {
        Pet petToDelete = petRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pet not found with ID: " + id));

        if (appointmentRepository.existsByPet_PetID(id)) {
            throw new DataIntegrityViolationException("This pet has existing appointments and cannot be deleted. Please cancel or reassign appointments first.");
        }

        List<MedicalRecord> records = medicalRecordRepository.findByPet_PetID((long)id);
        if (records != null && !records.isEmpty()) {
            medicalRecordRepository.deleteAll(records);
        }

        petRepository.delete(petToDelete);
        System.out.println("Pet and related medical records (if any) deleted: " + id);
    }


    @Override
    public List<Pet> getAllPets() {
        return petRepository.findAll();
    }

    @Override
    public List<Pet> getPetsByClinicId(int clinicId) {
        Clinic clinic = clinicRepository.findById((long) clinicId)
                .orElseThrow(() -> new RuntimeException("Clinic not found"));
        return petRepository.findByClinic(clinic);
    }

    @Override
    public Pet getPetById(int id) {
        return petRepository.findById(id).orElse(null);
    }

    @Override
    @Transactional
    public Pet createPet(Pet pet) {
        setAssociations(pet);
        return petRepository.save(pet);
    }

    @Override
    @Transactional
    public Pet updatePet(Pet pet) {
        setAssociations(pet);
        return petRepository.save(pet);
    }

    private void setAssociations(Pet pet) {

        if (pet.getClient() != null && pet.getClient().getClientId() != null) {
            pet.setClient(clientRepository.findById(pet.getClient().getClientId())
                    .orElseThrow(() -> new RuntimeException("Client not found for ID: " + pet.getClient().getClientId())));
        } else if (pet.getClient() != null && pet.getClient().getUser() != null && pet.getClient().getUser().getUsername() != null) {

            Client clientByUsername = clientRepository.findByUserUsername(pet.getClient().getUser().getUsername())
                    .orElseThrow(() -> new RuntimeException("Client not found for username: " + pet.getClient().getUser().getUsername()));
            pet.setClient(clientByUsername);
        } else {

            throw new RuntimeException("Client information is missing or invalid for the pet.");
        }


        pet.setSpecies(speciesRepository.findById(pet.getSpecies().getSpeciesID())
                .orElseThrow(() -> new RuntimeException("Species not found")));
        pet.setBreed(breedRepository.findById(pet.getBreed().getBreedID())
                .orElseThrow(() -> new RuntimeException("Breed not found")));
        pet.setGender(genderRepository.findById(pet.getGender().getGenderID())
                .orElseThrow(() -> new RuntimeException("Gender not found")));


        if (pet.getClinic() != null && pet.getClinic().getClinicId() != null) {
            pet.setClinic(clinicRepository.findById(pet.getClinic().getClinicId())
                    .orElseThrow(() -> new RuntimeException("Clinic not found for ID: " + pet.getClinic().getClinicId())));
        } else {
            pet.setClinic(null);
        }
    }


    @Override
    public List<Pet> getPetsByClient(Client client) {
        return petRepository.findByClient(client);
    }

    @Override
    public List<Pet> getPetsByNameContaining(String keyword) {
        return petRepository.findByNameContainingIgnoreCase(keyword);
    }

    @Override
    @Transactional
    public void save(Pet pet) {
        setAssociations(pet);
        petRepository.save(pet);
    }
}