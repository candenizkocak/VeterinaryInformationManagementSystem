package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Species;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SpeciesRepository extends JpaRepository<Species, Integer> {
}
