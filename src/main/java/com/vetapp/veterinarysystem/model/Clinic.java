package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Clinics")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Clinic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ClinicID")
    private Long clinicId;

    @OneToOne
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    private User user;

    @Column(name = "ClinicName", nullable = false, length = 100)
    private String clinicName;

    @Column(name = "Location", length = 255)
    private String location;
}