package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "Reviews")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ReviewID")
    private Long reviewId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AppointmentID", nullable = false, unique = true)
    @ToString.Exclude // <--- Eklendi
    private Appointment appointment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VeterinaryID", nullable = false)
    @ToString.Exclude // <--- Eklendi
    private Veterinary veterinary;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ClientID", nullable = false)
    @ToString.Exclude // <--- Eklendi
    private Client client;

    @Column(name = "Rating", nullable = false)
    private int rating;

    @Column(name = "Comment", columnDefinition = "TEXT")
    private String comment;

    @Column(name = "ReviewDate", nullable = false)
    private LocalDate reviewDate;
}


/* eski kodlar:


package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "Reviews")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ReviewID")
    private Long reviewId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AppointmentID", nullable = false, unique = true)
    private Appointment appointment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VeterinaryID", nullable = false)
    private Veterinary veterinary;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ClientID", nullable = false)
    private Client client;

    @Column(name = "Rating", nullable = false)
    private int rating;

    @Column(name = "Comment", columnDefinition = "TEXT")
    private String comment;

    @Column(name = "ReviewDate", nullable = false)
    private LocalDate reviewDate;
}
 */