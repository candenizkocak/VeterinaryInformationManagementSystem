package com.vetapp.veterinarysystem.dto;

import lombok.Data;

@Data
public class MedicalRecordDto {
    private String date;
    private String description;
    private String treatment;
}
