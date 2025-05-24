package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.ClinicVeterinary;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository;
import com.vetapp.veterinarysystem.service.ClinicVeterinaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ClinicVeterinaryServiceImpl implements ClinicVeterinaryService {

    private final ClinicVeterinaryRepository clinicVeterinaryRepository;

    @Override
    @Transactional
    public void assignVeterinaryToClinic(Clinic clinic, Veterinary veterinary) {
        // Check if already assigned
        boolean alreadyAssigned = clinicVeterinaryRepository.findByClinic(clinic).stream()
                .anyMatch(cv -> cv.getVeterinary().getVeterinaryId().equals(veterinary.getVeterinaryId()));

        if (alreadyAssigned) {
            throw new RuntimeException("Veterinary is already assigned to this clinic.");
        }

        ClinicVeterinary relation = ClinicVeterinary.builder()
                .clinic(clinic)
                .veterinary(veterinary)
                .build();
        clinicVeterinaryRepository.save(relation);
    }

    @Override
    @Transactional
    public void removeVeterinaryFromClinic(Clinic clinic, Veterinary veterinary) {
        clinicVeterinaryRepository.deleteByClinicAndVeterinary(clinic, veterinary);
    }
}

