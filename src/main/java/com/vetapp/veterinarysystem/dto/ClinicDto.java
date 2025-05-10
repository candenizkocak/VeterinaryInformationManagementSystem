package com.vetapp.veterinarysystem.dto;

import lombok.Data;

@Data
public class ClinicDto {
    private Long clinicId;
    private Long userId;
    private String clinicName;
    private String location;
}
