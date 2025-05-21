package com.vetapp.veterinarysystem.dto;

import lombok.Data;
import java.util.List;

@Data
public class ClientDetailDto {
    private String firstName;
    private String lastName;
    private String address;
    private List<PetInfoDto> pets;
}
