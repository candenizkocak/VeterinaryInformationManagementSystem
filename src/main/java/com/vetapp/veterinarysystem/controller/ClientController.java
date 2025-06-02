package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.PetInfoDto;
import com.vetapp.veterinarysystem.model.*;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.dto.ClientDetailDto;
import com.vetapp.veterinarysystem.dto.ClientDto;
import com.vetapp.veterinarysystem.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/api/clients")
@RequiredArgsConstructor
public class ClientController {

    private final ClientService clientService;
    private final UserRepository userRepository;
    private final ClientRepository clientRepository;

    // Yeni eklenenler:
    private final PetService petService;
    private final SpeciesService speciesService;
    private final BreedService breedService;
    private final GenderService genderService;

    // --- DTO'lu KISIMLAR AYNEN KALIYOR ---
    @PostMapping
    public ResponseEntity<ClientDto> createClient(@RequestBody ClientDto clientDto) {
        return ResponseEntity.ok(clientService.createClient(clientDto));
    }

    @GetMapping("/register")
    public String showClientRegistrationForm(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        model.addAttribute("clientDto", new ClientDto());
        return "client/register_client";
    }

    @PostMapping("/register")
    public String processClientRegistration(@ModelAttribute("clientDto") ClientDto clientDto, Principal principal) {
        if (principal == null) return "redirect:/login";

        clientDto.setUsername(principal.getName());
        clientService.createClient(clientDto);

        return "redirect:/";
    }

    @GetMapping("/detail/{id}")
    public ResponseEntity<ClientDto> getClient(@PathVariable Long id) {
        return ResponseEntity.ok(clientService.getClientById(id));
    }

    @GetMapping
    public ResponseEntity<List<ClientDto>> getAllClients() {
        return ResponseEntity.ok(clientService.getAllClients());
    }

    @PutMapping("/detail/{id}")
    public ResponseEntity<ClientDto> updateClient(@PathVariable Long id, @RequestBody ClientDto dto) {
        return ResponseEntity.ok(clientService.updateClient(id, dto));
    }

    @DeleteMapping("/detail/{id}")
    public ResponseEntity<Void> deleteClient(@PathVariable Long id) {
        clientService.deleteClient(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/animals")
    public String getMyAnimalsApi(Principal principal, Model model) {
        if (principal == null) return "redirect:/login";

        String username = principal.getName();
        List<PetInfoDto> pets = clientService.getPetsOfClient(username);

        model.addAttribute("pets", pets);
        return "client/my_animals";
    }


    @GetMapping("/my-animals")
    public String getMyAnimals(Model model, Principal principal) {
        if (principal == null) return "redirect:/login";
        String username = principal.getName();

        List<PetInfoDto> pets = clientService.getPetsOfClient(username);

        model.addAttribute("pets", pets);
        return "client/my_animals";
    }



    @GetMapping("/add-animal")
    public String showAddAnimalForm(Model model, Principal principal) {
        if (principal == null) return "redirect:/login";

        model.addAttribute("pet", new Pet());
        model.addAttribute("speciesList", speciesService.getAllSpecies());
        model.addAttribute("breedList", breedService.getAllBreeds());
        model.addAttribute("genderList", genderService.getAllGenders());

        return "client/add_animal";
    }

    @PostMapping("/add-animal")
    public String addAnimal(@ModelAttribute("pet") Pet pet, Principal principal, Model model) {
        if (principal == null) return "redirect:/login";

        String username = principal.getName();
        Client client = clientService.getClientByUsername(username);

        Species species = speciesService.getById(pet.getSpecies().getSpeciesID());
        Breed breed = breedService.getById(pet.getBreed().getBreedID());
        Gender gender = genderService.getById(pet.getGender().getGenderID());

        pet.setClient(client);
        pet.setSpecies(species);
        pet.setBreed(breed);
        pet.setGender(gender);

        petService.save(pet);

        model.addAttribute("success", true);
        model.addAttribute("pet", new Pet()); // Formu sıfırla
        model.addAttribute("speciesList", speciesService.getAllSpecies());
        model.addAttribute("breedList", breedService.getAllBreeds());
        model.addAttribute("genderList", genderService.getAllGenders());

        return "client/add_animal";

    }

    @PostMapping("/delete-animal/{id}")
    public String deleteAnimal(@PathVariable("id") int id, Principal principal) {
        System.out.println("Silme işlemi ID: " + id);
        petService.deletePetById(id);
        return "redirect:/api/clients/my-animals";
    }


}
