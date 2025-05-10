package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "MedicalRecords")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MedicalRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RecordID")
    private Long recordId;

    @ManyToOne
    @JoinColumn(name = "PetID", nullable = false)
    private Pet pet;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID", nullable = false)
    private Veterinary veterinary;

    @Column(name = "Diagnosis", columnDefinition = "TEXT")
    private String diagnosis;

    @Column(name = "Treatment", columnDefinition = "TEXT")
    private String treatment;

    @Column(name = "RecordDate")
    private LocalDate recordDate;
}

/**
 Bu sınıf, her tıbbi kaydın bir evcil hayvana ve bir veterinere ait olduğunu belirtir.

 🔁 Ayrıca Pet ve Veterinary sınıflarında @OneToMany(mappedBy = "...") şeklinde ilişkileri göstererek çift taraflı yapı kurabilirsin.
 */