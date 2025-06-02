package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Client;
import com.vetapp.veterinarysystem.model.Pet;

import java.util.List;

public interface PetService {
    List<Pet> getAllPets();
    List<Pet> getPetsByClinicId(int clinicId);
    List<Pet> getPetsByNameContaining(String query);
    Pet getPetById(int id);
    Pet createPet(Pet pet);
    Pet updatePet(Pet pet);
    void deletePet(int id);

    void save(Pet pet);

    List<Pet> getPetsByClient(Client client);


    void deletePetById(int id);
}
