package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.AppointmentDTO;
import com.vetapp.veterinarysystem.dto.VeterinaryDto;
import com.vetapp.veterinarysystem.model.*; // Import all models
import com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository;
import com.vetapp.veterinarysystem.repository.VeterinaryRepository;
import com.vetapp.veterinarysystem.service.*; // Import all services
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/veterinary/appointments")
@RequiredArgsConstructor
public class AppointmentController {

    private final AppointmentService appointmentService;
    private final PetService petService;
    private final ClinicService clinicService;
    // private final VeterinaryService veterinaryService; // Already have veterinaryRepository for loggedInVet
    private final ClinicVeterinaryRepository clinicVeterinaryRepository;
    private final VeterinaryRepository veterinaryRepository;

    // Services for new clinical data
    private final MedicalRecordService medicalRecordService;
    private final VaccineTypeService vaccineTypeService;
    private final VaccinationService vaccinationService; // Assuming you create this
    private final SurgeryTypeService surgeryTypeService;
    private final SurgeryService surgeryService;


    private Veterinary getLoggedInVeterinary(Principal principal) {
        if (principal == null) {
            throw new IllegalStateException("User not authenticated.");
        }
        String username = principal.getName();
        return veterinaryRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Veterinary user not found: " + username + ". Ensure a Veterinary record is linked to this user."));
    }

    @GetMapping
    public String showAppointments(Model model, Principal principal) {
        Veterinary loggedInVeterinary = getLoggedInVeterinary(principal);
        List<Appointment> veterinaryAppointments = appointmentService.getAppointmentsByVeterinaryId(loggedInVeterinary.getVeterinaryId());
        model.addAttribute("appointments", convertToDtoList(veterinaryAppointments));

        model.addAttribute("appointment", new Appointment()); // For new appointment form
        model.addAttribute("pets", petService.getAllPets());
        List<Clinic> associatedClinics = clinicVeterinaryRepository.findByVeterinary(loggedInVeterinary)
                .stream().map(ClinicVeterinary::getClinic).distinct().collect(Collectors.toList());
        model.addAttribute("clinics", associatedClinics);
        model.addAttribute("loggedInVeterinary", loggedInVeterinary);
        return "veterinary/appointments"; // This JSP will handle both list and add/edit form
    }

    @PostMapping("/add")
    public String addAppointment(@ModelAttribute Appointment appointment, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Veterinary loggedInVeterinary = getLoggedInVeterinary(principal);
            appointment.setVeterinary(loggedInVeterinary);
            // Additional validation for clinic association if needed
            appointmentService.createAppointment(appointment);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment added successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding appointment: " + e.getMessage());
        }
        return "redirect:/veterinary/appointments";
    }

    @GetMapping("/edit/{id}")
    public String editAppointmentForm(@PathVariable Long id, Model model, Principal principal) {
        Veterinary loggedInVeterinary = getLoggedInVeterinary(principal);
        Appointment appointmentToEdit = appointmentService.getAppointmentById(id);

        if (appointmentToEdit == null || !appointmentToEdit.getVeterinary().getVeterinaryId().equals(loggedInVeterinary.getVeterinaryId())) {
            return "redirect:/veterinary/appointments?error=not_found_or_unauthorized";
        }
        model.addAttribute("appointment", appointmentToEdit);

        // For the main list part of the page (if your JSP structure requires it)
        List<Appointment> veterinaryAppointments = appointmentService.getAppointmentsByVeterinaryId(loggedInVeterinary.getVeterinaryId());
        model.addAttribute("appointments", convertToDtoList(veterinaryAppointments));

        // Data for the form
        model.addAttribute("pets", petService.getAllPets());
        List<Clinic> associatedClinics = clinicVeterinaryRepository.findByVeterinary(loggedInVeterinary)
                .stream().map(ClinicVeterinary::getClinic).distinct().collect(Collectors.toList());
        model.addAttribute("clinics", associatedClinics);
        model.addAttribute("loggedInVeterinary", loggedInVeterinary);

        // Data for new clinical fields
        // Try to find existing medical record for this pet, by this vet, on this appointment's date
        Optional<MedicalRecord> existingMedicalRecord = medicalRecordService.findByPetAndVeterinaryAndDate(
                appointmentToEdit.getPet(),
                loggedInVeterinary,
                appointmentToEdit.getAppointmentDate().toLocalDate()
        );
        model.addAttribute("medicalRecord", existingMedicalRecord.orElse(new MedicalRecord())); // Pass existing or new

        model.addAttribute("allVaccineTypes", vaccineTypeService.getAllVaccineTypes());
        model.addAttribute("allSurgeryTypes", surgeryTypeService.getAllSurgeryTypes());

        // Potentially load existing vaccinations/surgeries for display, if needed
        // For now, focusing on adding new ones via the form

        return "veterinary/appointments"; // This JSP will display the form with appointment data
    }

    @PostMapping("/update")
    public String updateAppointment(@ModelAttribute Appointment appointmentForm, Principal principal, RedirectAttributes redirectAttributes,
                                    @RequestParam(required = false) String medicalRecordDescription,
                                    @RequestParam(required = false) String medicalRecordTreatment,
                                    @RequestParam(required = false) Long selectedVaccineTypeId,
                                    @RequestParam(required = false) Long selectedSurgeryTypeId,
                                    @RequestParam(required = false) String surgeryNotes,
                                    @RequestParam(required = false) Long existingMedicalRecordId) { // To identify if we update an MR
        Veterinary loggedInVeterinary = getLoggedInVeterinary(principal);
        Appointment existingAppointment = appointmentService.getAppointmentById(appointmentForm.getAppointmentId());

        if (existingAppointment == null || !existingAppointment.getVeterinary().getVeterinaryId().equals(loggedInVeterinary.getVeterinaryId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Appointment not found or not authorized for update.");
            return "redirect:/veterinary/appointments";
        }

        try {
            // 1. Update Appointment core details
            existingAppointment.setPet(petService.getPetById(appointmentForm.getPet().getPetID().intValue())); // Ensure Pet is fully loaded
            existingAppointment.setClinic(clinicService.getClinicById(appointmentForm.getClinic().getClinicId())); // Ensure Clinic is fully loaded
            existingAppointment.setAppointmentDate(appointmentForm.getAppointmentDate());
            existingAppointment.setStatus(appointmentForm.getStatus());
            // Vet remains loggedInVeterinary
            appointmentService.updateAppointment(existingAppointment.getAppointmentId(), existingAppointment);

            // 2. Handle Medical Record (Upsert: Update if existingMedicalRecordId is present, else Create)
            MedicalRecord medicalRecord;
            if (existingMedicalRecordId != null) {
                medicalRecord = medicalRecordService.getMedicalRecordById(existingMedicalRecordId);
                if (medicalRecord == null ||
                        !medicalRecord.getPet().getPetID().equals(existingAppointment.getPet().getPetID()) ||
                        !medicalRecord.getVeterinary().getVeterinaryId().equals(loggedInVeterinary.getVeterinaryId())) {
                    // Safety check or create new if mismatch
                    medicalRecord = new MedicalRecord();
                    medicalRecord.setPet(existingAppointment.getPet());
                    medicalRecord.setVeterinary(loggedInVeterinary);
                }
            } else {
                // Attempt to find by pet, vet, date to avoid duplicates if form re-submitted without ID
                Optional<MedicalRecord> foundMr = medicalRecordService.findByPetAndVeterinaryAndDate(
                        existingAppointment.getPet(), loggedInVeterinary, existingAppointment.getAppointmentDate().toLocalDate());
                if (foundMr.isPresent()) {
                    medicalRecord = foundMr.get();
                } else {
                    medicalRecord = new MedicalRecord();
                    medicalRecord.setPet(existingAppointment.getPet());
                    medicalRecord.setVeterinary(loggedInVeterinary);
                }
            }

            medicalRecord.setDate(existingAppointment.getAppointmentDate().toLocalDate());
            medicalRecord.setDescription(medicalRecordDescription);
            medicalRecord.setTreatment(medicalRecordTreatment);
            MedicalRecord savedMedicalRecord = medicalRecordService.saveMedicalRecordForVet(medicalRecord); // saveMedicalRecord should handle create/update

            // 3. Handle Vaccination (Add new if selected)
            if (selectedVaccineTypeId != null) {
                VaccineType vaccineType = vaccineTypeService.getVaccineTypeById(selectedVaccineTypeId);
                if (vaccineType != null) {
                    Vaccination newVaccination = new Vaccination();
                    newVaccination.setPet(existingAppointment.getPet());
                    newVaccination.setVaccineType(vaccineType);
                    newVaccination.setDateAdministered(existingAppointment.getAppointmentDate().toLocalDate());
                    // newVaccination.setMedicalRecord(savedMedicalRecord); // Optional: Link Vaccination to MedicalRecord
                    vaccinationService.saveVaccination(newVaccination); // Assuming this service/method exists
                }
            }

            // 4. Handle Surgery (Add new if selected)
            if (selectedSurgeryTypeId != null) {
                SurgeryType surgeryType = surgeryTypeService.getSurgeryTypeById(selectedSurgeryTypeId);
                if (surgeryType != null) {
                    Surgery newSurgery = new Surgery();
                    newSurgery.setPet(existingAppointment.getPet());
                    newSurgery.setSurgeryType(surgeryType);
                    newSurgery.setVeterinary(loggedInVeterinary);
                    newSurgery.setDate(existingAppointment.getAppointmentDate().toLocalDate());
                    newSurgery.setNotes(surgeryNotes);
                    newSurgery.setMedicalRecord(savedMedicalRecord); // Link Surgery to the MedicalRecord
                    surgeryService.saveSurgery(newSurgery);
                }
            }

            redirectAttributes.addFlashAttribute("successMessage", "Appointment and clinical records updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating appointment: " + e.getMessage());
            // Optionally, return to the edit form with error and retain input values
            // model.addAttribute("appointment", appointmentForm); // and other model attributes
            // return "veterinary/appointments";
        }
        return "redirect:/veterinary/appointments";
    }


    @PostMapping("/delete/{id}")
    public String deleteAppointment(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        Veterinary loggedInVeterinary = getLoggedInVeterinary(principal);
        Appointment appointmentToDelete = appointmentService.getAppointmentById(id);

        if (appointmentToDelete == null || !appointmentToDelete.getVeterinary().getVeterinaryId().equals(loggedInVeterinary.getVeterinaryId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Appointment not found or not authorized for deletion.");
            return "redirect:/veterinary/appointments";
        }
        try {
            appointmentService.deleteAppointment(id);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting appointment: " + e.getMessage());
        }
        return "redirect:/veterinary/appointments";
    }

    // AJAX endpoint for admin/appointments might still use this. Not strictly needed for vet's own page if vet is fixed.
    @GetMapping(value = "/veterinaries-by-clinic/{clinicId}", produces = "application/json")
    @ResponseBody
    public List<VeterinaryDto> getVeterinariesByClinic(@PathVariable Long clinicId) {
        List<Veterinary> vets = clinicVeterinaryRepository.findVeterinariesByClinicId(clinicId);
        return vets.stream().map(v -> new VeterinaryDto(
                v.getVeterinaryId(), v.getFirstName(), v.getLastName(), v.getSpecialization(),
                v.getUser() != null ? v.getUser().getUsername() : "N/A"
        )).collect(Collectors.toList());
    }

    private List<AppointmentDTO> convertToDtoList(List<Appointment> appointmentList) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        return appointmentList.stream().map(a -> {
            AppointmentDTO dto = new AppointmentDTO();
            dto.setAppointmentId(a.getAppointmentId());
            if (a.getAppointmentDate() != null) {
                dto.setAppointmentDate(a.getAppointmentDate().format(formatter));
            }
            dto.setStatus(a.getStatus());
            dto.setPetName(a.getPet() != null ? a.getPet().getName() : "N/A");
            dto.setClientName(a.getPet() != null && a.getPet().getClient() != null ?
                    a.getPet().getClient().getFirstName() + " " + a.getPet().getClient().getLastName() : "N/A");
            dto.setClinicName(a.getClinic() != null ? a.getClinic().getClinicName() : "N/A");
            dto.setVeterinaryName(a.getVeterinary() != null ?
                    a.getVeterinary().getFirstName() + " " + a.getVeterinary().getLastName() : "N/A");
            return dto;
        }).collect(Collectors.toList());
    }
}