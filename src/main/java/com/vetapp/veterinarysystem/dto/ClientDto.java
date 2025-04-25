package com.vetapp.veterinarysystem.dto;

import lombok.Data;

@Data
public class ClientDto {
    private Long clientId;
    private String firstName;
    private String lastName;
    private String address;
    private String username;
}
