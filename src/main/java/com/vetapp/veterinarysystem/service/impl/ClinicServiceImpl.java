package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.ClinicDto;
import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClinicRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.service.ClinicService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClinicServiceImpl implements ClinicService {

    private final ClinicRepository clinicRepository;
    private final UserRepository userRepository;

    @Override
    public List<Clinic> getAllClinics() {
        return clinicRepository.findAll();
    }

    @Override
    public Clinic createClinic(ClinicDto clinicDto) {
        User user = userRepository.findById(clinicDto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Clinic clinic = new Clinic();
        clinic.setUser(user);
        clinic.setClinicName(clinicDto.getClinicName());
        clinic.setLocation(clinicDto.getLocation());

        return clinicRepository.save(clinic);
    }

    @Override
    public Clinic getClinicById(Long id) {
        return clinicRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Clinic not found with ID: " + id));
    }

    @Override
    public Clinic updateClinic(ClinicDto clinicDto) {
        Clinic clinic = clinicRepository.findById(clinicDto.getClinicId())
                .orElseThrow(() -> new RuntimeException("Clinic not found with ID: " + clinicDto.getClinicId()));

        User user = userRepository.findById(clinicDto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        clinic.setClinicName(clinicDto.getClinicName());
        clinic.setLocation(clinicDto.getLocation());
        clinic.setUser(user);

        return clinicRepository.save(clinic);
    }

    @Override
    public void deleteClinic(Long id) {
        clinicRepository.deleteById(id);
    }
}
