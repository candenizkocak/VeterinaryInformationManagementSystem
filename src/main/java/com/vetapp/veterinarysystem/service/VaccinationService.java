package com.vetapp.veterinarysystem.service;
import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.model.Vaccination;

import java.time.LocalDate;
import java.util.List;

public interface VaccinationService {
    Vaccination saveVaccination(Vaccination vaccination);
    List<Vaccination> getVaccinationsByPetId(Long petId);
    // Add other methods as needed

    List<Vaccination> getVaccinationsByPetAndDate(Pet pet, LocalDate date);
}