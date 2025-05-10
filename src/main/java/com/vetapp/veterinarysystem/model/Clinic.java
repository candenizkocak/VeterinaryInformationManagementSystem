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
    private Long clinicId;  //Cenk clinicID olarak yapmıştı clinicID yapınca hata veriyor şu an benim yaptığım kısımlar yüzünden

    @OneToOne
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    private User user;

    @Column(name = "ClinicName", nullable = false, length = 100)
    private String clinicName;

    @Column(name = "Location", length = 255)
    private String location;

    /**
    // ClinicVeterinaries ilişkisi için (opsiyonel)
    @OneToMany(mappedBy = "clinic", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ClinicVeterinary> clinicVeterinaries;

    // Appointments ilişkisi için (opsiyonel)
    @OneToMany(mappedBy = "clinic", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Appointment> appointments;

    // Inventory ilişkisi için (opsiyonel)
    @OneToMany(mappedBy = "clinic", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Inventory> inventoryItems;
    */
}



/**************CENKİN KODLARI************

package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Clinics")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Clinic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int clinicID;

    @OneToOne
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    private User user;


    @Column(nullable = false)
    private String clinicName;

    @Column(nullable = false)
    private String location;
}
*/