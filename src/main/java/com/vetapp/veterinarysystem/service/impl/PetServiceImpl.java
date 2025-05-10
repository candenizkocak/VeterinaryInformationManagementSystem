package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.*;
import com.vetapp.veterinarysystem.repository.*;
import com.vetapp.veterinarysystem.service.PetService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
    public Pet createPet(Pet pet) {
        setAssociations(pet);
        return petRepository.save(pet);
    }

    @Override
    public Pet updatePet(Pet pet) {
        setAssociations(pet);
        return petRepository.save(pet);
    }

    private void setAssociations(Pet pet) {
        pet.setClient(clientRepository.findById(pet.getClient().getClientId())
                .orElseThrow(() -> new RuntimeException("Client not found")));
        pet.setSpecies(speciesRepository.findById(pet.getSpecies().getSpeciesID())
                .orElseThrow(() -> new RuntimeException("Species not found")));
        pet.setBreed(breedRepository.findById(pet.getBreed().getBreedID())
                .orElseThrow(() -> new RuntimeException("Breed not found")));
        pet.setGender(genderRepository.findById(pet.getGender().getGenderID())
                .orElseThrow(() -> new RuntimeException("Gender not found")));
        pet.setClinic(clinicRepository.findById(pet.getClinic().getClinicId())
                .orElseThrow(() -> new RuntimeException("Clinic not found")));
    }

    @Override
    public void deletePet(int id) {
        petRepository.deleteById(id);
    }

    @Override
    public List<Pet> getPetsByNameContaining(String keyword) {
        return petRepository.findByNameContainingIgnoreCase(keyword);
    }
}
