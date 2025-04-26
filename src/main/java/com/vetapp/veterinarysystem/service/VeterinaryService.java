package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.dto.VeterinaryDto;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface VeterinaryService {
    VeterinaryDto createVeterinary(VeterinaryDto veterinaryDto);
    VeterinaryDto getVeterinaryById(Long id);
    List<VeterinaryDto> getAllVeterinaries();
    VeterinaryDto updateVeterinary(Long id, VeterinaryDto veterinaryDto);
    void deleteVeterinary(Long id);

    // Login işlemi
    ResponseEntity<?> login(String username, String password);
}
