package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.dto.ClinicDto;
import com.vetapp.veterinarysystem.model.Clinic;

import java.util.List;

public interface ClinicService {
    List<Clinic> getAllClinics();
    Clinic createClinic(ClinicDto clinicDto);
    void deleteClinic(int id);
}
