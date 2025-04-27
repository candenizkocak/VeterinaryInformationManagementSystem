package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.ClinicDto;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.service.ClinicService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/clinics")
@RequiredArgsConstructor
public class ClinicController {

    private final ClinicService clinicService;
    private final UserRepository userRepository;

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
    public String deleteClinic(@PathVariable("id") int id) {
        clinicService.deleteClinic(id);
        return "redirect:/admin/clinics";
    }
}

