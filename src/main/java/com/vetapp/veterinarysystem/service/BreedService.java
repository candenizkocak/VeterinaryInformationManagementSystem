package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Breed;
import java.util.List;

public interface BreedService {
    List<Breed> getAllBreeds();

    Breed getById(int breedID);
}