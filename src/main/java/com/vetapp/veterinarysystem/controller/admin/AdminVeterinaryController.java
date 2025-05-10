package com.vetapp.veterinarysystem.controller.admin;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.ClinicVeterinary;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.repository.ClinicRepository;
import com.vetapp.veterinarysystem.service.VeterinaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/veterinaries")
@RequiredArgsConstructor
public class AdminVeterinaryController {

    private final VeterinaryService veterinaryService;
    private final UserRepository userRepository;
    private final ClinicRepository clinicRepository;
    private final com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository clinicVeterinaryRepository;


    @GetMapping
    public String listVeterinaries(Model model) {
        model.addAttribute("veterinaries", veterinaryService.getAllVeterinaries());
        model.addAttribute("users", userRepository.findByRoleRoleName("VETERINARY"));
        return "admin/veterinaries";
    }

    @PostMapping("/create")
    public String createVeterinary(@RequestParam String firstName,
                                   @RequestParam String lastName,
                                   @RequestParam String specialization,
                                   @RequestParam Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Veterinary veterinary = Veterinary.builder()
                .firstName(firstName)
                .lastName(lastName)
                .specialization(specialization)
                .user(user)
                .build();

        veterinaryService.createVeterinaryFromEntity(veterinary);
        return "redirect:/admin/veterinaries";
    }

    @PostMapping("/delete/{id}")
    public String deleteVeterinary(@PathVariable Long id) {
        veterinaryService.deleteVeterinary(id);
        return "redirect:/admin/veterinaries";
    }

    @GetMapping("/edit/{id}")
    public String editVeterinaryForm(@PathVariable Long id, Model model) {
        Veterinary veterinary = veterinaryService.getVeterinaryEntityById(id);
        model.addAttribute("veterinary", veterinary);
        model.addAttribute("users", userRepository.findByRoleRoleName("VETERINARY"));
        return "admin/edit_veterinary";
    }

    @PostMapping("/update")
    public String updateVeterinary(@RequestParam Long veterinaryID,
                                   @RequestParam String firstName,
                                   @RequestParam String lastName,
                                   @RequestParam String specialization,
                                   @RequestParam Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Veterinary vet = veterinaryService.getVeterinaryEntityById(veterinaryID);
        vet.setFirstName(firstName);
        vet.setLastName(lastName);
        vet.setSpecialization(specialization);
        vet.setUser(user);

        veterinaryService.updateVeterinaryEntity(vet);
        return "redirect:/admin/veterinaries";
    }

    @GetMapping("/{id}/assign-clinic")
    public String assignClinicForm(@PathVariable Long id, Model model) {
        Veterinary veterinary = veterinaryService.getVeterinaryEntityById(id);
        List<Clinic> clinics = clinicRepository.findAll();
        model.addAttribute("veterinary", veterinary);
        model.addAttribute("clinics", clinics);
        return "admin/assign_clinic_to_vet";
    }

    @PostMapping("/{id}/assign-clinic")
    public String assignClinicToVet(@PathVariable Long id, @RequestParam Long clinicId) {
        Veterinary veterinary = veterinaryService.getVeterinaryEntityById(id);
        Clinic clinic = clinicRepository.findById(clinicId).orElseThrow();

        ClinicVeterinary cv = new ClinicVeterinary();
        cv.setClinic(clinic);
        cv.setVeterinary(veterinary);

        clinicVeterinaryRepository.save(cv);
        return "redirect:/admin/veterinaries";
    }
}
