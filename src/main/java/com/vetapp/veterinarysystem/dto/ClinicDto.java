package com.vetapp.veterinarysystem.dto;

import lombok.AllArgsConstructor; // Ekleyin
import lombok.Data;
import lombok.NoArgsConstructor; // Ekleyin

import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClinicDto {
    private Long clinicId;
    private Long userId;
    private String clinicName;

    private Integer cityCode;
    private Integer districtCode;
    private Long localityCode;
    private String streetAddress;
    private String postalCode;

    private String formattedAddress;

    private LocalTime openingHour;
    private LocalTime closingHour;
}