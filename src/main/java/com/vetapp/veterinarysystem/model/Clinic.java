package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalTime;

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

    // --- ESKİ LOCATION SÜTUNU KALDIRILDI ---
    // @Column(name = "Location", length = 255)
    // private String location;

    // --- YENİ ADRES BİLGİLERİ EKLENDİ ---
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "LocalityCode", referencedColumnName = "Code") // Mahalle kodu (BIGINT)
    private Locality locality;

    @Column(name = "StreetAddress", length = 255) // Sokak adı, bina numarası gibi detaylar
    private String streetAddress;

    @Column(name = "PostalCode", length = 10) // Posta kodu
    private String postalCode;
    // --- YENİ ADRES BİLGİLERİ SONU ---

    @Column(name = "OpeningHour")
    private LocalTime openingHour;

    @Column(name = "ClosingHour")
    private LocalTime closingHour;

}