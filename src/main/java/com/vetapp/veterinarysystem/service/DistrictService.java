package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.District;
import java.util.List;
import java.util.Optional;

public interface DistrictService {
    List<District> getDistrictsByCityCode(int cityCode);
    Optional<District> getDistrictByCode(int code);
}