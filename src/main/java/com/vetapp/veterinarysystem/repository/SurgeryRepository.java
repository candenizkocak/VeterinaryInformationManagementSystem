package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Surgery;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SurgeryRepository extends JpaRepository<Surgery, Long> {
    List<Surgery> findByPet_PetID(Long petId);
    List<Surgery> findByMedicalRecord_MedicalRecordId(Long medicalRecordId);
}
