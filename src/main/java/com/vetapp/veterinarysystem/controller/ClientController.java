package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.PetInfoDto;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.dto.ClientDetailDto;
import com.vetapp.veterinarysystem.dto.ClientDto;
import com.vetapp.veterinarysystem.service.ClientService;
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

    @PostMapping
    public ResponseEntity<ClientDto> createClient(@RequestBody ClientDto clientDto) {
        return ResponseEntity.ok(clientService.createClient(clientDto));
    }

    // Yeni: Register formunu gösteren GET endpoint
    @GetMapping("/register")
    public String showClientRegistrationForm(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        model.addAttribute("clientDto", new ClientDto());
        return "client/register_client";
    }

    // Register formunu işleyen POST endpoint (zaten vardı)
    @PostMapping("/register")
    public String processClientRegistration(@ModelAttribute("clientDto") ClientDto clientDto, Principal principal) {
        if (principal == null) return "redirect:/login";

        clientDto.setUsername(principal.getName());
        clientService.createClient(clientDto);

        return "redirect:/";
    }

    // ID ile client getirme (mapping değişti!)
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
    public String getMyAnimals(Principal principal, Model model) {
        if (principal == null) return "redirect:/login";

        String username = principal.getName();
        List<PetInfoDto> pets = clientService.getPetsOfClient(username);

        model.addAttribute("pets", pets);
        return "client/my_animals";
    }
}
