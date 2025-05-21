package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.MedicalRecord;
import com.vetapp.veterinarysystem.repository.MedicalRecordRepository;
import com.vetapp.veterinarysystem.service.MedicalRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MedicalRecordServiceImpl implements MedicalRecordService {

    private final MedicalRecordRepository medicalRecordRepository;

    @Override
    public List<MedicalRecord> getAllMedicalRecords() {
        return medicalRecordRepository.findAll();
    }

    @Override
    public List<MedicalRecord> getMedicalRecordsByPetId(Long petId) {
        return medicalRecordRepository.findByPet_PetID(petId);
    }

    @Override
    public MedicalRecord getById(Long id) {
        return medicalRecordRepository.findById(id).orElse(null);
    }

    @Override
    public void saveMedicalRecord(MedicalRecord record) {
        medicalRecordRepository.save(record);
    }
    @Override
    public MedicalRecord getMedicalRecordById(Long id) {
        return medicalRecordRepository.findById(id).orElse(null);
    }

    @Override
    public void deleteMedicalRecord(Long id) {
        medicalRecordRepository.deleteById(id);
    }

}
