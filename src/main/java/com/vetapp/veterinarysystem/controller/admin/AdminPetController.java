package com.vetapp.veterinarysystem.controller.admin;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.Pet;
import com.vetapp.veterinarysystem.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/pets")
@RequiredArgsConstructor
public class AdminPetController {

    private final PetService petService;
    private final ClientService clientService;
    private final SpeciesService speciesService;
    private final BreedService breedService;
    private final GenderService genderService;
    private final ClinicService clinicService;

    @GetMapping
    public String listPets(Model model) {
        model.addAttribute("pets", petService.getAllPets());
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("speciesList", speciesService.getAllSpecies());
        model.addAttribute("breeds", breedService.getAllBreeds());
        model.addAttribute("genders", genderService.getAllGenders());
        model.addAttribute("clinics", clinicService.getAllClinics());
        return "admin/pets";
    }

    @GetMapping("/{clinicId}/pets")
    public String listClinicPets(@PathVariable Long clinicId, Model model) {
        Clinic clinic = clinicService.getClinicById(clinicId);
        List<Pet> pets = petService.getPetsByClinicId(clinicId.intValue());

        model.addAttribute("clinic", clinic);
        model.addAttribute("pets", pets);
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("speciesList", speciesService.getAllSpecies());
        model.addAttribute("breeds", breedService.getAllBreeds());
        model.addAttribute("genders", genderService.getAllGenders());

        return "admin/clinic_pets";
    }

    @PostMapping("/create")
    public String createPet(@ModelAttribute Pet pet) {
        petService.createPet(pet);
        return "redirect:/admin/pets";
    }

    @PostMapping("/{clinicId}/pets/create")
    public String addPetToClinic(@PathVariable Long clinicId, @ModelAttribute Pet pet) {
        Clinic clinic = clinicService.getClinicById(clinicId);
        pet.setClinic(clinic);
        petService.createPet(pet);
        return "redirect:/admin/pets/" + clinicId + "/pets";
    }


    @GetMapping("/edit/{id}")
    public String editPetForm(@PathVariable int id, Model model) {
        Pet pet = petService.getPetById(id);
        model.addAttribute("pet", pet);
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("speciesList", speciesService.getAllSpecies());
        model.addAttribute("breeds", breedService.getAllBreeds());
        model.addAttribute("genders", genderService.getAllGenders());
        model.addAttribute("clinics", clinicService.getAllClinics());
        return "admin/edit_pet";
    }

    @GetMapping("/{clinicId}/pets/edit/{petId}")
    public String editClinicPetForm(@PathVariable Long clinicId, @PathVariable int petId, Model model) {
        Pet pet = petService.getPetById(petId);
        model.addAttribute("clinicId", clinicId);
        model.addAttribute("pet", pet);
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("speciesList", speciesService.getAllSpecies());
        model.addAttribute("breeds", breedService.getAllBreeds());
        model.addAttribute("genders", genderService.getAllGenders());
        return "admin/edit_clinic_pet";
    }


    @PostMapping("/update")
    public String updatePet(@ModelAttribute Pet pet) {
        petService.updatePet(pet);
        return "redirect:/admin/pets";
    }

    @PostMapping("/update-clinic")
    public String updateClinicPet(@ModelAttribute Pet pet) {
        petService.updatePet(pet);
        Long clinicId = pet.getClinic().getClinicId();
        return "redirect:/admin/pets/" + clinicId + "/pets";
    }

    @PostMapping("/delete/{id}")
    public String deletePet(@PathVariable int id) {
        petService.deletePet(id);
        return "redirect:/admin/pets";
    }

    @GetMapping("/search")
    @ResponseBody
    public List<Pet> searchPets(@RequestParam("query") String query) {
        return petService.getPetsByNameContaining(query);
    }

}
