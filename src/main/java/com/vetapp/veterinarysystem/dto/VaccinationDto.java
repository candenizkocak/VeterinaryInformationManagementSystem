package com.vetapp.veterinarysystem.dto;

import lombok.Data;



@Data
public class VaccinationDto {
    private String vaccineName;
    private String dateAdministered; // Changed from LocalDate to String
    private String nextDueDate;      // Changed from LocalDate to String
    private boolean upcoming;        // New field to indicate if nextDueDate is in the future
}