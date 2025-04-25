package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClinicRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/clinics")
@RequiredArgsConstructor
public class ClinicController {

    private final ClinicRepository clinicRepository;
    private final UserRepository userRepository;

    @GetMapping
    public String showClinics(Model model) {
        List<Clinic> clinics = clinicRepository.findAll();
        List<User> users = userRepository.findByRoleRoleName("CLINIC");
        model.addAttribute("clinics", clinics);
        model.addAttribute("users", users);
        return "admin/clinics";
    }

    @PostMapping("/create")
    public String createClinic(@ModelAttribute Clinic clinic) {
        clinicRepository.save(clinic);
        return "redirect:/admin/clinics";
    }

    @PostMapping("/delete/{id}")
    public String deleteClinic(@PathVariable("id") int id) {
        clinicRepository.deleteById(id);
        return "redirect:/admin/clinics";
    }
}
