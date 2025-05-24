package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Surgery;
import com.vetapp.veterinarysystem.repository.SurgeryRepository;
import com.vetapp.veterinarysystem.service.SurgeryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SurgeryServiceImpl implements SurgeryService {

    private final SurgeryRepository surgeryRepository;

    @Override
    public List<Surgery> getSurgeriesByPetId(Long petId) {
        return surgeryRepository.findByPet_PetID(petId);
    }

    @Override
    public void saveSurgery(Surgery surgery) {
        surgeryRepository.save(surgery);
    }

    @Override
    public List<Surgery> getSurgeriesByMedicalRecordId(Long medicalRecordId) {
        return surgeryRepository.findByMedicalRecord_MedicalRecordId(medicalRecordId);
    }
}
