package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.MedicalRecord;
import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.model.Veterinary;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface MedicalRecordService {
    List<MedicalRecord> getAllMedicalRecords();
    List<MedicalRecord> getMedicalRecordsByPetId(Long petId);
    MedicalRecord getById(Long id);
    void saveMedicalRecord(MedicalRecord record);
    MedicalRecord getMedicalRecordById(Long id);
    void deleteMedicalRecord(Long id);

    Optional<MedicalRecord> findByPetAndVeterinaryAndDate(Pet pet, Veterinary veterinary, LocalDate date);
    MedicalRecord saveMedicalRecordForVet(MedicalRecord record);
}
