package com.vetapp.veterinarysystem.dto;

import lombok.Data;

@Data
public class ClientAccountSettingsDto {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private Integer cityCode;
    private Integer districtCode;
    private Long localityCode;
    private String streetAddress;
    private String apartmentNumber;
    private String postalCode;

}