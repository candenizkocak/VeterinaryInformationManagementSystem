package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.District;
import com.vetapp.veterinarysystem.repository.DistrictRepository;
import com.vetapp.veterinarysystem.service.DistrictService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DistrictServiceImpl implements DistrictService {

    private final DistrictRepository districtRepository;

    @Override
    public List<District> getDistrictsByCityCode(int cityCode) {
        return districtRepository.findByCityCodeOrderByNameAsc(cityCode);
    }

    @Override
    public Optional<District> getDistrictByCode(int code) {
        return districtRepository.findById(code);
    }
}