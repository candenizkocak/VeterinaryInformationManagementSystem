package com.vetapp.veterinarysystem.dto;

import lombok.Data;

import java.util.List;

@Data
public class PetInfoDto {
    private int id;
    private String name;
    private String species;
    private String breed;
    private String gender;
    private String clinicName;
    private int age;
    // Changed this line:
    private List<VaccinationDto> vaccinations; // Changed from List<String> vaccineNames
    private List<MedicalRecordDto> medicalRecords; // Tedaviler ve hastalıklar
}