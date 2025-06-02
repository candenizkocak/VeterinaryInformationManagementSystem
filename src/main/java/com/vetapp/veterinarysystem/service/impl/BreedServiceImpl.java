package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Breed;
import com.vetapp.veterinarysystem.repository.BreedRepository;
import com.vetapp.veterinarysystem.service.BreedService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BreedServiceImpl implements BreedService {
    private final BreedRepository breedRepository;

    @Override
    public List<Breed> getAllBreeds() {
        return breedRepository.findAll();
    }

    @Override
    public Breed getById(int id) {
        return breedRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Breed not found with id: " + id));
    }
}