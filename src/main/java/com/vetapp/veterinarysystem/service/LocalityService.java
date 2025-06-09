package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Locality;
import java.util.List;
import java.util.Optional;

public interface LocalityService {
    List<Locality> getLocalitiesByDistrictCode(int districtCode);
    Optional<Locality> getLocalityByCode(Long code);
}