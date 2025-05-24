package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.MedicalRecord;
import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.MedicalRecordRepository;
import com.vetapp.veterinarysystem.service.MedicalRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

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

    @Override
    public Optional<MedicalRecord> findByPetAndVeterinaryAndDate(Pet pet, Veterinary veterinary, LocalDate date) {
        return medicalRecordRepository.findByPetAndVeterinaryAndDate(pet, veterinary, date);
    }

    @Override
    public MedicalRecord saveMedicalRecordForVet(MedicalRecord record) { // void -> MedicalRecord olarak değiştirildi
        return medicalRecordRepository.save(record); // save metodu zaten entity'yi döndürür
    }

}
