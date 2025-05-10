package com.vetapp.veterinarysystem.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Pets")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PetID")
    private int petID;

    @Column(name = "Name", nullable = false, length = 50)
    private String name;

    @Column(name = "Age")
    private int age;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ClientID", nullable = false)
    @JsonBackReference //appointment.jsp ile ilgili
    private Client client;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "SpeciesID", nullable = false)
    private Species species;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "BreedID", nullable = false)
    private Breed breed;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "GenderID", nullable = false)
    private Gender gender;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ClinicID")
    private Clinic clinic;
}
