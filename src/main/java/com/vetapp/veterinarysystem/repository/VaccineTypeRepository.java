package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.VaccineType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VaccineTypeRepository extends JpaRepository<VaccineType, Long> {
}