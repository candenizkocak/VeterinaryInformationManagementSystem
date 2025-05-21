package com.vetapp.veterinarysystem.dto;

import lombok.Data;

import java.time.LocalTime;

@Data
public class ClinicDto {
    private Long clinicId;
    private Long userId;
    private String clinicName;
    private String location;
    private LocalTime openingHour;
    private LocalTime closingHour;
}
