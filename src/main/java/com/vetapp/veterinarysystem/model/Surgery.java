package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "Surgeries")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Surgery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SurgeryID")
    private Long surgeryId;

    @ManyToOne
    @JoinColumn(name = "PetID", nullable = false)
    private Pet pet;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID", nullable = false)
    private Veterinary veterinary;

    @ManyToOne
    @JoinColumn(name = "SurgeryTypeID", nullable = false)
    private SurgeryType surgeryType;

    @Column(name = "Date")
    private LocalDate date;

    @Column(name = "Notes", columnDefinition = "TEXT")
    private String notes;
}
