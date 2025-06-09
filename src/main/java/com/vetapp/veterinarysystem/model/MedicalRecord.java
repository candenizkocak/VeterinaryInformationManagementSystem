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
    private Long medicalRecordId;

    @ManyToOne
    @JoinColumn(name = "PetID")
    @ToString.Exclude // <--- Eklendi
    private Pet pet;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID")
    @ToString.Exclude // <--- Eklendi
    private Veterinary veterinary;

    @Column(name = "RecordDate")
    private LocalDate date;

    @Column(name = "Diagnosis")
    private String description;

    @Column(name = "Treatment")
    private String treatment;
}


/* ÖNCEKİ KODLAR

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
    private Long medicalRecordId;

    @ManyToOne
    @JoinColumn(name = "PetID")
    private Pet pet;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID")
    private Veterinary veterinary;

    @Column(name = "RecordDate")
    private LocalDate date;

    @Column(name = "Diagnosis")
    private String description;

    @Column(name = "Treatment")
    private String treatment;
}

 */