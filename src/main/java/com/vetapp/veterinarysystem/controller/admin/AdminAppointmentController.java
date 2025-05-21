package com.vetapp.veterinarysystem.controller.admin;

import com.vetapp.veterinarysystem.dto.AppointmentDTO;
import com.vetapp.veterinarysystem.dto.VeterinaryDto;
import com.vetapp.veterinarysystem.model.Appointment;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository;
import com.vetapp.veterinarysystem.service.AppointmentService;
import com.vetapp.veterinarysystem.service.ClinicService;
import com.vetapp.veterinarysystem.service.PetService;
import com.vetapp.veterinarysystem.service.VeterinaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/appointments")
@RequiredArgsConstructor
public class AdminAppointmentController {

    private final AppointmentService appointmentService;
    private final PetService petService;
    private final ClinicService clinicService;
    private final VeterinaryService veterinaryService;
    private final ClinicVeterinaryRepository clinicVeterinaryRepository;

    @GetMapping
    public String showAppointments(Model model) {
        model.addAttribute("appointments", convertToDtoList(appointmentService.getAllAppointments()));
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("pets", petService.getAllPets());
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("veterinaries", veterinaryService.getAllVeterinaries());
        return "admin/appointments";
    }

    @PostMapping("/add")
    public String addAppointment(@ModelAttribute Appointment appointment,
                                 @RequestParam(required = false) Long clinicId,
                                 @RequestParam(required = false) Long veterinaryId,
                                 @RequestParam(required = false) Integer petId,
                                 Model model) {

        if (clinicId != null)
            appointment.setClinic(clinicService.getClinicById(clinicId));

        if (veterinaryId != null)
            appointment.setVeterinary(veterinaryService.getVeterinaryEntityById(veterinaryId));

        if (petId != null)
            appointment.setPet(petService.getPetById(petId));

        if (appointment.getClinic() == null || appointment.getVeterinary() == null || appointment.getPet() == null || appointment.getAppointmentDate() == null) {
            model.addAttribute("appointments", convertToDtoList(appointmentService.getAllAppointments()));
            model.addAttribute("pets", petService.getAllPets());
            model.addAttribute("clinics", clinicService.getAllClinics());
            model.addAttribute("veterinaries", clinicVeterinaryRepository.findVeterinariesByClinicId(clinicId));
            model.addAttribute("appointment", appointment);
            model.addAttribute("selectedClinicId", clinicId);
            model.addAttribute("selectedVetId", veterinaryId);
            model.addAttribute("slots", List.of());
            return "admin/appointments";
        }

        appointmentService.createAppointment(appointment);
        return "redirect:/admin/appointments";
    }

    @GetMapping("/edit/{id}")
    public String editAppointmentForm(@PathVariable Long id, Model model) {
        model.addAttribute("appointment", appointmentService.getAppointmentById(id));
        model.addAttribute("appointments", convertToDtoList(appointmentService.getAllAppointments()));
        model.addAttribute("pets", petService.getAllPets());
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("veterinaries", veterinaryService.getAllVeterinaries());
        return "admin/appointments";
    }

    @PostMapping("/update")
    public String updateAppointment(@ModelAttribute Appointment appointment) {
        appointmentService.updateAppointment(appointment.getAppointmentId(), appointment);
        return "redirect:/admin/appointments";
    }

    @PostMapping("/delete/{id}")
    public String deleteAppointment(@PathVariable Long id) {
        appointmentService.deleteAppointment(id);
        return "redirect:/admin/appointments";
    }

    @PostMapping("/timeslots")
    public String showAvailableTimeSlots(@RequestParam Long clinicId,
                                         @RequestParam Long veterinaryId,
                                         @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
                                         Model model) {

        List<String> slots = appointmentService.getAvailableTimeSlots(clinicId, veterinaryId, date)
                .stream()
                .map(dt -> dt.toLocalTime().toString())
                .toList();

        model.addAttribute("appointments", appointmentService.getAllAppointments().stream().map(a -> {
            AppointmentDTO dto = new AppointmentDTO();
            dto.setAppointmentId(a.getAppointmentId());
            dto.setAppointmentDate(a.getAppointmentDate().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm")));
            dto.setStatus(a.getStatus());
            dto.setPetName(a.getPet().getName());
            dto.setClinicName(a.getClinic().getClinicName());
            dto.setVeterinaryName(a.getVeterinary().getFirstName() + " " + a.getVeterinary().getLastName());
            return dto;
        }).toList());

        model.addAttribute("appointment", new Appointment());
        model.addAttribute("slots", slots);
        model.addAttribute("selectedClinicId", clinicId);
        model.addAttribute("selectedVetId", veterinaryId);
        model.addAttribute("selectedDate", date);
        model.addAttribute("pets", petService.getAllPets());
        model.addAttribute("clinics", clinicService.getAllClinics());
        model.addAttribute("veterinaries", clinicVeterinaryRepository.findVeterinariesByClinicId(clinicId));

        return "admin/appointments";
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
    private List<AppointmentDTO> convertToDtoList(List<Appointment> appointmentList) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        return appointmentList.stream().map(a -> {
            AppointmentDTO dto = new AppointmentDTO();
            dto.setAppointmentId(a.getAppointmentId());
            dto.setAppointmentDate(a.getAppointmentDate().format(formatter));
            dto.setStatus(a.getStatus());
            dto.setPetName(a.getPet().getName());
            dto.setClinicName(a.getClinic().getClinicName());
            dto.setVeterinaryName(a.getVeterinary().getFirstName() + " " + a.getVeterinary().getLastName());
            return dto;
        }).toList();
    }

}
