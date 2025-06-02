package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Client;
import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.model.Clinic;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PetRepository extends JpaRepository<Pet, Integer> {
    List<Pet> findByClinic(Clinic clinic);
    List<Pet> findByNameContainingIgnoreCase(String name);

    List<Pet> findByClient(Client client);

}
