package com.vetapp.veterinarysystem.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "Species")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Species {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SpeciesID")
    private int speciesID;

    @Column(name = "SpeciesName", nullable = false, length = 50)
    private String speciesName;

    @OneToMany(mappedBy = "species", cascade = CascadeType.ALL)
    @JsonManagedReference  // appointment.jsp ile ilgli
    private List<Breed> breeds;

    @OneToMany(mappedBy = "species", cascade = CascadeType.ALL)
    private List<Pet> pets;
}
