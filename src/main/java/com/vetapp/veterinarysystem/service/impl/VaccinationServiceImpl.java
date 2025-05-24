package com.vetapp.veterinarysystem.service.impl;
import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.model.Vaccination;
import com.vetapp.veterinarysystem.repository.VaccinationRepository;
import com.vetapp.veterinarysystem.service.VaccinationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VaccinationServiceImpl implements VaccinationService {
    private final VaccinationRepository vaccinationRepository;

    @Override
    public Vaccination saveVaccination(Vaccination vaccination) {
        return vaccinationRepository.save(vaccination);
    }

    @Override
    public List<Vaccination> getVaccinationsByPetId(Long petId) {
        // Assuming Pet has an ID field like petID
        // Adjust if your Pet model and VaccinationRepository differ
        return vaccinationRepository.findByPet_PetID(petId); // You'll need this method in VaccinationRepository
    }

    @Override
    public List<Vaccination> getVaccinationsByPetAndDate(Pet pet, LocalDate date) {
        return vaccinationRepository.findByPetAndDateAdministered(pet, date);
    }
}