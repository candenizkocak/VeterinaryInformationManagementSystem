package com.vetapp.veterinarysystem.dto;

import lombok.Data;

import java.util.List;

@Data
public class PetInfoDto {
    private String name;
    private String species;
    private String breed;
    private String gender;
    private String clinicName;
    private int age;
    private List<String> vaccineNames;  // Aşılar
    private List<MedicalRecordDto> medicalRecords; // Tedaviler ve hastalıklar
}

