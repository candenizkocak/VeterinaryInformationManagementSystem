package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.Veterinary;

public interface ClinicVeterinaryService {
    void assignVeterinaryToClinic(Clinic clinic, Veterinary veterinary);
    void removeVeterinaryFromClinic(Clinic clinic, Veterinary veterinary);
}

