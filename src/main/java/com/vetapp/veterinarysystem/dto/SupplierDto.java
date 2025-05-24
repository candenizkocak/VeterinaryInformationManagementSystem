package com.vetapp.veterinarysystem.dto;

import lombok.Data;

@Data
public class SupplierDto {
    private Long supplierId;
    private String companyName;
    private String contactName;
    private String phone;
    private String email;
    private String address;
}