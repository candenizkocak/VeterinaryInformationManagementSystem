package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "Veterinaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Veterinary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "VeterinaryID")
    private Long veterinaryId;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    private User user;

    @Column(name = "FirstName", length = 50)
    private String firstName;

    @Column(name = "LastName", length = 50)
    private String lastName;

    @Column(name = "Specialization", length = 100)
    private String specialization;

    // OneToMany ilişkileri için @ToString.Exclude ekleyin
    @OneToMany(mappedBy = "veterinary", cascade = CascadeType.ALL)
    @ToString.Exclude // <--- YENİ EKLENDİ
    private List<Appointment> appointments;

    @OneToMany(mappedBy = "veterinary", cascade = CascadeType.ALL)
    @ToString.Exclude // <--- YENİ EKLENDİ
    private List<ClinicVeterinary> clinicVeterinaries;

    @OneToMany(mappedBy = "veterinary", cascade = CascadeType.ALL)
    @ToString.Exclude // <--- YENİ EKLENDİ
    private List<MedicalRecord> medicalRecords;

    @OneToMany(mappedBy = "veterinary", cascade = CascadeType.ALL)
    @ToString.Exclude // <--- YENİ EKLENDİ
    private List<Review> reviews;

    @OneToMany(mappedBy = "veterinary", cascade = CascadeType.ALL)
    @ToString.Exclude // <--- YENİ EKLENDİ
    private List<Surgery> surgeries;
}


/********************BENİM İLK KODLAR******************

package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Table(name = "Veterinaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Veterinary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int veterinaryID;

    @OneToOne
    @JoinColumn(name = "userID", referencedColumnName = "userID")
    private User user;

    private String firstName;
    private String lastName;
    private String specialization;
}
*/
