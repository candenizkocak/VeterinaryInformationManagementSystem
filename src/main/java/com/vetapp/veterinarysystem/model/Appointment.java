package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "Appointments")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "AppointmentID")
    private Long appointmentId;

    @ManyToOne
    @JoinColumn(name = "PetID")
    private Pet pet;

    @ManyToOne
    @JoinColumn(name = "ClinicID")
    private Clinic clinic;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID")
    private Veterinary veterinary;

    @Column(name = "AppointmentDate")
    private LocalDateTime appointmentDate;

    @Column(name = "Status")
    private String status;
}
