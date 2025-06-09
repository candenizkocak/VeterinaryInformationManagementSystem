package com.vetapp.veterinarysystem.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LocalityDto {
    private Long code;
    private String name;
    private int parentCode;
}