package com.vetapp.veterinarysystem.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DistrictDto {
    private int code;
    private String name;
    private int parentCode;
}