package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.VeterinaryDto;
import com.vetapp.veterinarysystem.model.Appointment;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository;
import com.vetapp.veterinarysystem.service.AppointmentService;
import com.vetapp.veterinarysystem.service.ClinicService;
import com.vetapp.veterinarysystem.service.PetService;
import com.vetapp.veterinarysystem.service.VeterinaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/veterinary/appointments")
@RequiredArgsConstructor
public class AppointmentController {

    private final AppointmentService appointmentService;
    private final PetService petService;
    private final ClinicService clinicService;
    private final VeterinaryService veterinaryService;
    private final ClinicVeterinaryRepository clinicVeterinaryRepository;

    @GetMapping
    public String showAppointments(Model model) {
        model.addAttribute("appointments", appointmentService.getAllAppointments());
        model.addAttribute("pets", petService.getAllPets());
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("veterinaries", veterinaryService.getAllVeterinaries());
        model.addAttribute("appointment", new Appointment());
        return "veterinary/appointments";
    }

    @PostMapping("/add")
    public String addAppointment(@ModelAttribute Appointment appointment) {
        appointmentService.createAppointment(appointment);
        return "redirect:/veterinary/appointments";
    }

    @GetMapping("/edit/{id}")
    public String editAppointmentForm(@PathVariable Long id, Model model) {
        model.addAttribute("appointment", appointmentService.getAppointmentById(id));
        model.addAttribute("appointments", appointmentService.getAllAppointments());
        model.addAttribute("pets", petService.getAllPets());
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("veterinaries", veterinaryService.getAllVeterinaries());
        return "veterinary/appointments";
    }

    @PostMapping("/update")
    public String updateAppointment(@ModelAttribute Appointment appointment) {
        appointmentService.updateAppointment(appointment.getAppointmentId(), appointment);
        return "redirect:/veterinary/appointments";
    }

    @PostMapping("/delete/{id}")
    public String deleteAppointment(@PathVariable Long id) {
        appointmentService.deleteAppointment(id);
        return "redirect:/veterinary/appointments";
    }
    @GetMapping(value = "/veterinaries-by-clinic/{clinicId}", produces = "application/json")
    @ResponseBody
    public List<VeterinaryDto> getVeterinariesByClinic(@PathVariable Long clinicId) {
        List<Veterinary> vets = clinicVeterinaryRepository.findVeterinariesByClinicId(clinicId);
        return vets.stream().map(v -> new VeterinaryDto(
                v.getVeterinaryId(),
                v.getFirstName(),
                v.getLastName(),
                v.getSpecialization(),
                v.getUser() != null ? v.getUser().getUsername() : "N/A"
        )).toList();
    }
}
