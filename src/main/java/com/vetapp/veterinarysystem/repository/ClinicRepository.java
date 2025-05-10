package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Clinic;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClinicRepository extends JpaRepository<Clinic, Long> {
}
