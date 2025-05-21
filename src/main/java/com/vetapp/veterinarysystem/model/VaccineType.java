package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "VaccineTypes")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VaccineType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "VaccineTypeID")
    private Long vaccineTypeId;

    @Column(name = "VaccineName")
    private String vaccineName;
}
