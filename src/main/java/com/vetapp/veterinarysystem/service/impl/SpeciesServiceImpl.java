package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Species;
import com.vetapp.veterinarysystem.repository.SpeciesRepository;
import com.vetapp.veterinarysystem.service.SpeciesService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SpeciesServiceImpl implements SpeciesService {
    private final SpeciesRepository speciesRepository;

    @Override
    public List<Species> getAllSpecies() {
        return speciesRepository.findAll();
    }
}