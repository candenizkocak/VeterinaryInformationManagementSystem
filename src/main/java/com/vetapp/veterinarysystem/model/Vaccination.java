package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "Vaccinations")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vaccination {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "VaccinationID")
    private Long vaccinationId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PetID", nullable = false)
    private Pet pet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VaccineTypeID", nullable = false)
    private VaccineType vaccineType;

    @Column(name = "DateAdministered")
    private LocalDate dateAdministered;

    @Column(name = "NextDueDate")
    private LocalDate nextDueDate;
}
