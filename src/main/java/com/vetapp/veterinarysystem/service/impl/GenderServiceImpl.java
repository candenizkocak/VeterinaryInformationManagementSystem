package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Gender;
import com.vetapp.veterinarysystem.repository.GenderRepository;
import com.vetapp.veterinarysystem.service.GenderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GenderServiceImpl implements GenderService {
    private final GenderRepository genderRepository;

    @Override
    public List<Gender> getAllGenders() {
        return genderRepository.findAll();
    }

    @Override
    public Gender getById(int id) {
        return genderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Gender not found with id: " + id));
    }
    
}