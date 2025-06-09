package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

@Entity
@Table(name = "Genders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Gender {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "GenderID")
    private int genderID;

    @Column(name = "GenderName", nullable = false, length = 20)
    private String genderName;

    @OneToMany(mappedBy = "gender", cascade = CascadeType.ALL)
    @ToString.Exclude // <--- Eklendi
    private List<Pet> pets;
}


/* ÖNCEKİ KODLAR
package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "Genders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Gender {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "GenderID")
    private int genderID;

    @Column(name = "GenderName", nullable = false, length = 20)
    private String genderName;

    @OneToMany(mappedBy = "gender", cascade = CascadeType.ALL)
    private List<Pet> pets;
}

 */