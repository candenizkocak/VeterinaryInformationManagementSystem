package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.MedicalRecord;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MedicalRecordRepository extends JpaRepository<MedicalRecord, Long> {
    List<MedicalRecord> findByPet_PetID(Long petId);
}
