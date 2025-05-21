package com.vetapp.veterinarysystem.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class VaccinationDto {
    private String vaccineName;
    private LocalDate dateAdministered;
    private LocalDate nextDueDate;
}
