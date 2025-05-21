package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.model.Vaccination;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VaccinationRepository extends JpaRepository<Vaccination, Long> {
    List<Vaccination> findByPet(Pet pet);
}
