package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.ClinicVeterinary;
import com.vetapp.veterinarysystem.model.Veterinary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClinicVeterinaryRepository extends JpaRepository<ClinicVeterinary, Long> {
    List<ClinicVeterinary> findByClinic(Clinic clinic);
    void deleteByClinicAndVeterinary(Clinic clinic, Veterinary veterinary);

}
