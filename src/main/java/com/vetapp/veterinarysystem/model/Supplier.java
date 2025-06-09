package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Suppliers")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Supplier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SupplierID")
    private Long supplierId;

    @Column(name = "CompanyName", nullable = false, length = 100)
    private String companyName;

    @Column(name = "ContactName", length = 100)
    private String contactName;

    @Column(name = "Phone", length = 20)
    private String phone;

    @Column(name = "Email", length = 100)
    private String email;

    // --- ESKİ ADRES SÜTUNU KALDIRILDI ---
    // @Column(name = "Address", length = 255)
    // private String address;

    // --- YENİ ADRES BİLGİLERİ EKLENDİ ---
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "LocalityCode", referencedColumnName = "Code") // Mahalle kodu (BIGINT)
    private Locality locality;

    @Column(name = "StreetAddress", length = 255) // Sokak adı, bina numarası gibi detaylar
    private String streetAddress;

    @Column(name = "PostalCode", length = 10) // Posta kodu
    private String postalCode;
    // --- YENİ ADRES BİLGİLERİ SONU ---
}