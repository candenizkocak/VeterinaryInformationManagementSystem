package com.vetapp.veterinarysystem.dto;

import lombok.Data;

@Data
public class ClinicDto {
    private int userId;
    private String clinicName;
    private String location;
}
