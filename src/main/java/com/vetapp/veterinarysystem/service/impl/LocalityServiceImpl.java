package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Locality;
import com.vetapp.veterinarysystem.repository.LocalityRepository;
import com.vetapp.veterinarysystem.service.LocalityService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class LocalityServiceImpl implements LocalityService {

    private final LocalityRepository localityRepository;

    @Override
    public List<Locality> getLocalitiesByDistrictCode(int districtCode) {
        return localityRepository.findByDistrictCodeOrderByNameAsc(districtCode);
    }

    @Override
    public Optional<Locality> getLocalityByCode(Long code) {
        return localityRepository.findById(code);
    }
}