package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;


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
    @ToString.Exclude // <--- Eklendi (Pet'e geri referans veriyor)
    private Pet pet;

    @ManyToOne
    @JoinColumn(name = "ClinicID")
    @ToString.Exclude // <--- Eklendi (Clinic'e geri referans veriyor)
    private Clinic clinic;

    @ManyToOne
    @JoinColumn(name = "VeterinaryID")
    @ToString.Exclude // <--- Eklendi (Veterinary'e geri referans veriyor)
    private Veterinary veterinary;


    @Column(name = "AppointmentDate")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) // Bu yardımcı olabilir
    private LocalDateTime appointmentDate;

    @Column(name = "Status")
    private String status;
}



//EMİR ESKİ KODLAR:

/* package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
        import lombok.*;
        import org.springframework.format.annotation.DateTimeFormat;


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
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) // Bu yardımcı olabilir
    private LocalDateTime appointmentDate;

    @Column(name = "Status")
    private String status;
}
*/