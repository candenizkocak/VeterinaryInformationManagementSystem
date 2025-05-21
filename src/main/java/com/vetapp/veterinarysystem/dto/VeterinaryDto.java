package com.vetapp.veterinarysystem.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class VeterinaryDto {
    private Long veterinaryId;
    private String firstName;
    private String lastName;
    private String specialization;
    private String username;

}
