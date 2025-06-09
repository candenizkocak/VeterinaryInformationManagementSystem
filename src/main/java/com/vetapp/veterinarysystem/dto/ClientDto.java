package com.vetapp.veterinarysystem.dto;

import lombok.Data;

@Data
public class ClientDto {
    private Long clientId;
    private String firstName;
    private String lastName;
    private Integer cityCode;
    private Integer districtCode;
    private Long localityCode;
    private String streetAddress;
    private String apartmentNumber;
    private String postalCode;
    private String username;
}