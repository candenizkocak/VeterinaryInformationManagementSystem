package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.MedicalRecord;

import java.util.List;

public interface MedicalRecordService {
    List<MedicalRecord> getAllMedicalRecords();
    List<MedicalRecord> getMedicalRecordsByPetId(Long petId);
    MedicalRecord getById(Long id);
    void saveMedicalRecord(MedicalRecord record);
    MedicalRecord getMedicalRecordById(Long id);
    void deleteMedicalRecord(Long id);

}
