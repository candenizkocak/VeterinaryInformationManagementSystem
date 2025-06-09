package com.vetapp.veterinarysystem.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "Clients")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ClientID")
    private Long clientId;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    private User user;

    @Column(name = "FirstName", length = 50)
    private String firstName;

    @Column(name = "LastName", length = 50)
    private String lastName;

    // --- ESKİ ADRES SÜTUNU KALDIRILDI ---
    // @Column(name = "Address", length = 255)
    // private String address;

    // --- YENİ ADRES BİLGİLERİ EKLENDİ ---
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "LocalityCode", referencedColumnName = "Code") // Mahalle kodu (BIGINT)
    private Locality locality;

    @Column(name = "StreetAddress", length = 255) // Sokak adı, bina numarası gibi detaylar
    private String streetAddress;

    @Column(name = "ApartmentNumber", length = 50) // Daire numarası (Sadece Client için)
    private String apartmentNumber;

    @Column(name = "PostalCode", length = 10) // Posta kodu
    private String postalCode;
    // --- YENİ ADRES BİLGİLERİ SONU ---

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    @JsonManagedReference
    @ToString.Exclude // <--- Eklendi
    private List<Pet> pets;

}


/*// ÖNCEKİ KODLAR
package com.vetapp.veterinarysystem.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "Clients")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ClientID")
    private Long clientId;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    private User user;

    @Column(name = "FirstName", length = 50)
    private String firstName;

    @Column(name = "LastName", length = 50)
    private String lastName;

    // --- ESKİ ADRES SÜTUNU KALDIRILDI ---
    // @Column(name = "Address", length = 255)
    // private String address;

    // --- YENİ ADRES BİLGİLERİ EKLENDİ ---
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "LocalityCode", referencedColumnName = "Code") // Mahalle kodu (BIGINT)
    private Locality locality;

    @Column(name = "StreetAddress", length = 255) // Sokak adı, bina numarası gibi detaylar
    private String streetAddress;

    @Column(name = "ApartmentNumber", length = 50) // Daire numarası (Sadece Client için)
    private String apartmentNumber;

    @Column(name = "PostalCode", length = 10) // Posta kodu
    private String postalCode;
    // --- YENİ ADRES BİLGİLERİ SONU ---

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<Pet> pets;

}
 */