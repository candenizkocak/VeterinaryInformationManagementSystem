// src/main/java/com/vetapp/veterinarysystem/service/impl/SurgeryTypeServiceImpl.java
package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.SurgeryType;
import com.vetapp.veterinarysystem.repository.SurgeryTypeRepository;
import com.vetapp.veterinarysystem.service.SurgeryTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SurgeryTypeServiceImpl implements SurgeryTypeService {

    private final SurgeryTypeRepository surgeryTypeRepository;

    @Override
    public List<SurgeryType> getAllSurgeryTypes() {
        return surgeryTypeRepository.findAll();
    }

    @Override
    public SurgeryType getSurgeryTypeById(Long id) {
        return surgeryTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Surgery Type not found with ID: " + id));
    }

    @Override
    public SurgeryType createSurgeryType(SurgeryType surgeryType) {
        // You can add validation logic here if needed (e.g., check for unique typeName)
        return surgeryTypeRepository.save(surgeryType);
    }

    @Override
    public void deleteSurgeryType(Long id) {
        // You might want to add checks here if a SurgeryType cannot be deleted
        // if it's referenced by existing Surgery records.
        surgeryTypeRepository.deleteById(id);
    }
}