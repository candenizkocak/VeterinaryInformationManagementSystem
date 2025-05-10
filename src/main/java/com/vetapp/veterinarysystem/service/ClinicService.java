package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.dto.ClinicDto;
import com.vetapp.veterinarysystem.model.Clinic;

import java.util.List;

public interface ClinicService {
    List<Clinic> getAllClinics();
    Clinic getClinicById(Long id);
    Clinic createClinic(ClinicDto clinicDto);
    Clinic updateClinic(ClinicDto clinicDto);
    void deleteClinic(Long id);
}