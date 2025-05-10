package com.vetapp.veterinarysystem.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "Breeds")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Breed {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BreedID")
    private int breedID;

    @Column(name = "BreedName", nullable = false, length = 50)
    private String breedName;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "SpeciesID", nullable = false)
    @JsonBackReference //appointment.jsp ile ilgili
    private Species species;

    @OneToMany(mappedBy = "breed", cascade = CascadeType.ALL)
    private List<Pet> pets;
}
