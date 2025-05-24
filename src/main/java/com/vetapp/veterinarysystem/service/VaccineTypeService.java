package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.VaccineType;
import java.util.List;

public interface VaccineTypeService {
    List<VaccineType> getAllVaccineTypes();
    VaccineType getVaccineTypeById(Long id);
    VaccineType createVaccineType(VaccineType vaccineType);
    void deleteVaccineType(Long id);
}