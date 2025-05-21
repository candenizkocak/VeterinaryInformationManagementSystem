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
}
