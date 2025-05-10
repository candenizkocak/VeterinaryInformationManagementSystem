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

/******DEEPSEEK*****
// VeterinaryService.java
package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Veterinary;
import java.util.List;
import java.util.Optional;

public interface VeterinaryService {
    List<Veterinary> findAll();
    Optional<Veterinary> findById(Long id);
    Veterinary save(Veterinary veterinary);
    void deleteById(Long id);
    List<Veterinary> findByClinicId(Long clinicId);
}
*/


