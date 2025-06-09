package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.City;
import com.vetapp.veterinarysystem.repository.CityRepository;
import com.vetapp.veterinarysystem.service.CityService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CityServiceImpl implements CityService {

    private final CityRepository cityRepository;

    @Override
    public List<City> getAllCities() {
        return cityRepository.findAllByOrderByNameAsc();
    }

    @Override
    public Optional<City> getCityByCode(int code) {
        return cityRepository.findById(code);
    }
}