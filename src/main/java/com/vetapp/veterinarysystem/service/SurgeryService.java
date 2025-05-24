package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Surgery;

import java.util.List;

public interface SurgeryService {
    List<Surgery> getSurgeriesByPetId(Long petId);
    void saveSurgery(Surgery surgery);
    List<Surgery> getSurgeriesByMedicalRecordId(Long medicalRecordId);
}