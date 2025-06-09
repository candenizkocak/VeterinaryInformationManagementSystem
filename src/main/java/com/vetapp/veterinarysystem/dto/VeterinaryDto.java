package com.vetapp.veterinarysystem.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
// import lombok.AllArgsConstructor; // <-- BU SATIRI SİLİN VEYA YORUMA ALIN

@Data
@NoArgsConstructor
public class VeterinaryDto {
    private Long veterinaryId;
    private String firstName;
    private String lastName;
    private String specialization;
    private String username;

    // <-- MANUEL CONSTRUCTOR -->
    public VeterinaryDto(Long veterinaryId, String firstName, String lastName, String specialization, String username) {
        this.veterinaryId = veterinaryId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.specialization = specialization;
        this.username = username;
    }
    // <-- MANUEL CONSTRUCTOR SONU -->
}