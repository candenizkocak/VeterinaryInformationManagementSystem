package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.VaccineType;
import com.vetapp.veterinarysystem.repository.VaccineTypeRepository;
import com.vetapp.veterinarysystem.service.VaccineTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VaccineTypeServiceImpl implements VaccineTypeService {

    private final VaccineTypeRepository vaccineTypeRepository;

    @Override
    public List<VaccineType> getAllVaccineTypes() {
        return vaccineTypeRepository.findAll();
    }

    @Override
    public VaccineType getVaccineTypeById(Long id) {
        return vaccineTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vaccine Type not found with ID: " + id));
    }

    @Override
    public VaccineType createVaccineType(VaccineType vaccineType) {
        return vaccineTypeRepository.save(vaccineType);
    }

    @Override
    public void deleteVaccineType(Long id) {
        vaccineTypeRepository.deleteById(id);
    }
}