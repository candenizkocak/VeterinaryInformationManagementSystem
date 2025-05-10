package com.vetapp.veterinarysystem.controller.admin;

import com.vetapp.veterinarysystem.dto.ClinicDto;
import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.ClinicVeterinary;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository;
import com.vetapp.veterinarysystem.service.ClinicService;
import com.vetapp.veterinarysystem.service.VeterinaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Controller
@RequestMapping("/admin/clinics")
@RequiredArgsConstructor
public class AdminClinicController {

    private final ClinicService clinicService;
    private final UserRepository userRepository;
    private final VeterinaryService veterinaryService;
    private final ClinicVeterinaryRepository clinicVeterinaryRepository;

    @GetMapping
    public String showClinics(Model model) {
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("users", userRepository.findByRoleRoleName("CLINIC"));
        return "admin/clinics";
    }

    @PostMapping("/create")
    public String createClinic(@ModelAttribute ClinicDto clinicDto) {
        clinicService.createClinic(clinicDto);
        return "redirect:/admin/clinics";
    }

    @PostMapping("/delete/{id}")
    public String deleteClinic(@PathVariable("id") long id) {
        clinicService.deleteClinic(id);
        return "redirect:/admin/clinics";
    }

    @GetMapping("/edit/{id}")
    public String editClinicForm(@PathVariable Long id, Model model) {
        model.addAttribute("clinic", clinicService.getClinicById(id));
        model.addAttribute("users", userRepository.findByRoleRoleName("CLINIC"));
        return "admin/edit_clinic";
    }

    @PostMapping("/update")
    public String updateClinic(@ModelAttribute ClinicDto clinicDto) {
        clinicService.updateClinic(clinicDto);
        return "redirect:/admin/clinics";
    }

    @GetMapping("/{id}/veterinaries")
    public String listClinicVeterinaries(@PathVariable Long id, Model model) {
        Clinic clinic = clinicService.getClinicById(id);
        List<ClinicVeterinary> assigned = clinicVeterinaryRepository.findByClinic(clinic);

        model.addAttribute("clinic", clinic);
        model.addAttribute("assignedVeterinaries", assigned);
        model.addAttribute("allVeterinaries", veterinaryService.getAllVeterinaryEntities());
        return "admin/clinic_veterinaries";
    }

    @PostMapping("/{clinicId}/veterinaries/assign")
    public String assignVeterinaryToClinic(@PathVariable Long clinicId,
                                           @RequestParam Long veterinaryId) {
        Clinic clinic = clinicService.getClinicById(clinicId);
        Veterinary vet = veterinaryService.getVeterinaryEntityById(veterinaryId);

        ClinicVeterinary relation = ClinicVeterinary.builder()
                .clinic(clinic)
                .veterinary(vet)
                .build();

        clinicVeterinaryRepository.save(relation);

        return "redirect:/admin/clinics/" + clinicId + "/veterinaries";
    }

    @PostMapping("/{clinicId}/veterinaries/remove/{veterinaryId}")
    @Transactional
    public String removeVeterinaryFromClinic(@PathVariable Long clinicId,
                                             @PathVariable Long veterinaryId) {
        Clinic clinic = clinicService.getClinicById(clinicId);
        Veterinary vet = veterinaryService.getVeterinaryEntityById(veterinaryId);

        clinicVeterinaryRepository.deleteByClinicAndVeterinary(clinic, vet);

        return "redirect:/admin/clinics/" + clinicId + "/veterinaries";
    }


}
