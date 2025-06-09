package com.vetapp.veterinarysystem.dto;

import lombok.AllArgsConstructor; // Ekleyin
import lombok.Data;
import lombok.NoArgsConstructor; // Ekleyin

@Data
@NoArgsConstructor // Ekleyin
@AllArgsConstructor // Ekleyin
public class SupplierDto {
    private Long supplierId;
    private String companyName;
    private String contactName;
    private String phone;
    private String email;
    // private String address; // Old field removed

    private Integer cityCode;
    private Integer districtCode;
    private Long localityCode;
    private String streetAddress;
    private String postalCode;

    private String formattedAddress;
}