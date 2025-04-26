package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.VeterinaryDto;
import com.vetapp.veterinarysystem.service.VeterinaryService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/veterinaries")
public class VeterinaryController {

    private final VeterinaryService veterinaryService;

    public VeterinaryController(VeterinaryService veterinaryService) {
        this.veterinaryService = veterinaryService;
    }

    // Create a new Veterinary
    @PostMapping
    public ResponseEntity<VeterinaryDto> createVeterinary(@RequestBody VeterinaryDto veterinaryDto) {
        VeterinaryDto createdVeterinary = veterinaryService.createVeterinary(veterinaryDto);
        return new ResponseEntity<>(createdVeterinary, HttpStatus.CREATED);
    }

    // Get Veterinary by ID
    @GetMapping("/{id}")
    public ResponseEntity<VeterinaryDto> getVeterinaryById(@PathVariable Long id) {
        VeterinaryDto veterinaryDto = veterinaryService.getVeterinaryById(id);
        return new ResponseEntity<>(veterinaryDto, HttpStatus.OK);
    }

    // Get all Veterinaries
    @GetMapping
    public ResponseEntity<List<VeterinaryDto>> getAllVeterinaries() {
        List<VeterinaryDto> veterinaries = veterinaryService.getAllVeterinaries();
        return new ResponseEntity<>(veterinaries, HttpStatus.OK);
    }

    // Delete Veterinary by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVeterinary(@PathVariable Long id) {
        veterinaryService.deleteVeterinary(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
