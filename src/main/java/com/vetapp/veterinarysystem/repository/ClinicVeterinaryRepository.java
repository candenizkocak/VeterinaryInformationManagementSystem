package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.ClinicVeterinary;
import com.vetapp.veterinarysystem.model.Veterinary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ClinicVeterinaryRepository extends JpaRepository<ClinicVeterinary, Long> {
    List<ClinicVeterinary> findByClinic(Clinic clinic);
    void deleteByClinicAndVeterinary(Clinic clinic, Veterinary veterinary);

    List<ClinicVeterinary> findByVeterinary(Veterinary veterinary); // Added


    @Query("SELECT cv.veterinary FROM ClinicVeterinary cv WHERE cv.clinic.clinicId = :clinicId")
    List<Veterinary> findVeterinariesByClinicId(@Param("clinicId") Long clinicId);
}
