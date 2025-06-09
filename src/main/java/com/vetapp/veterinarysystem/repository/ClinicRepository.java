package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Clinic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // Eklendi

import java.util.List;

public interface ClinicRepository extends JpaRepository<Clinic, Long> {
    @Query("SELECT c FROM Clinic c LEFT JOIN FETCH c.locality l LEFT JOIN FETCH l.district d LEFT JOIN FETCH d.city")
    List<Clinic> findAllWithAddressDetails();
}