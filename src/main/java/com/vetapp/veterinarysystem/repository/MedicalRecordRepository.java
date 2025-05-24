package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.MedicalRecord;
import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.model.Veterinary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface MedicalRecordRepository extends JpaRepository<MedicalRecord, Long> {
    List<MedicalRecord> findByPet_PetID(Long petId);
    Optional<MedicalRecord> findByPetAndVeterinaryAndDate(Pet pet, Veterinary veterinary, LocalDate date);
}
