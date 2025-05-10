package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Breed;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BreedRepository extends JpaRepository<Breed, Integer> {
}
