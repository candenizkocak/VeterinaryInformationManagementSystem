package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.*;
import com.vetapp.veterinarysystem.model.*;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/api/clients")
@RequiredArgsConstructor
public class ClientController {

    private final ClientService clientService;
    private final UserRepository userRepository;
    private final ClientRepository clientRepository;
    private final PetService petService;
    private final SpeciesService speciesService;
    private final BreedService breedService;
    private final GenderService genderService;
    private final AppointmentService appointmentService;
    private final ClinicService clinicService;
    private final VeterinaryService veterinaryService;
    private final ClinicVeterinaryRepository clinicVeterinaryRepository;
    private final ReviewService reviewService;
    private final CityService cityService;

    private Client getLoggedInClient(Principal principal) {
        if (principal == null) {
            throw new IllegalStateException("User not authenticated.");
        }
        String username = principal.getName();
        return clientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Client user not found: " + username + ". Ensure a Client record is linked to this user."));
    }

    @GetMapping("/register")
    public String showClientRegistrationForm(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        model.addAttribute("clientDto", new ClientDto());
        model.addAttribute("cities", cityService.getAllCities());
        return "client/register_client";
    }

    @PostMapping("/register")
    public String processClientRegistration(@ModelAttribute("clientDto") ClientDto clientDto, Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        try {
            clientDto.setUsername(principal.getName());
            clientService.createClient(clientDto);
            redirectAttributes.addFlashAttribute("successMessage", "Your client profile has been created successfully!");
            return "redirect:/";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error creating profile: " + e.getMessage());
            return "redirect:/api/clients/register";
        }
    }

    @GetMapping("/detail/{id}")
    public ResponseEntity<ClientDto> getClient(@PathVariable Long id) {
        return ResponseEntity.ok(clientService.getClientById(id));
    }

    @GetMapping
    public ResponseEntity<List<ClientDto>> getAllClients() {
        return ResponseEntity.ok(clientService.getAllClients());
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
    public String addAnimal(@ModelAttribute("pet") Pet pet, Principal principal, Model model, RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        try {
            String username = principal.getName();
            Client client = clientService.getClientByUsername(username);
            pet.setClient(client);
            pet.setSpecies(speciesService.getById(pet.getSpecies().getSpeciesID()));
            pet.setBreed(breedService.getById(pet.getBreed().getBreedID()));
            pet.setGender(genderService.getById(pet.getGender().getGenderID()));
            petService.save(pet);
            redirectAttributes.addFlashAttribute("success", true);
            return "redirect:/api/clients/my-animals";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error adding animal: " + e.getMessage());
            model.addAttribute("pet", pet);
            model.addAttribute("speciesList", speciesService.getAllSpecies());
            model.addAttribute("breedList", breedService.getAllBreeds());
            model.addAttribute("genderList", genderService.getAllGenders());
            return "client/add_animal";
        }
    }

    @PostMapping("/delete-animal/{id}")
    public String deleteAnimal(@PathVariable("id") int id, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            petService.deletePetById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Animal deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting animal: " + e.getMessage());
        }
        return "redirect:/api/clients/my-animals";
    }

    @GetMapping("/account-settings")
    public String showAccountSettings(Model model, Principal principal) {
        if (principal == null) return "redirect:/login";
        try {
            String username = principal.getName();
            ClientAccountSettingsDto dto = clientService.getAccountSettings(username);
            model.addAttribute("accountSettings", dto);
            model.addAttribute("cities", cityService.getAllCities());
            return "client/account_settings";
        } catch (Exception e) {
            model.addAttribute("error", "Account info could not be loaded: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping("/account-settings")
    public String updateAccountSettings(@ModelAttribute("accountSettings") ClientAccountSettingsDto dto, Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        try {
            String username = principal.getName();
            clientService.updateAccountSettings(username, dto);
            redirectAttributes.addFlashAttribute("success", true);
            return "redirect:/api/clients/account-settings";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating account settings: " + e.getMessage());
            return "redirect:/api/clients/account-settings";
        }
    }

    @GetMapping("/change-password")
    public String showChangePassword(Model model) {
        model.addAttribute("passwordChange", new PasswordChangeDto());
        return "client/change_password";
    }

    @PostMapping("/change-password")
    public String processChangePassword(@ModelAttribute("passwordChange") PasswordChangeDto dto, Principal principal, Model model) {
        if (principal == null) return "redirect:/login";
        String username = principal.getName();
        boolean result = clientService.changePassword(username, dto);
        if (result) {
            model.addAttribute("success", true);
        } else {
            model.addAttribute("error", "Password could not be changed. Please check your current password and try again.");
        }
        return "client/change_password";
    }

    @GetMapping("/appointments")
    public String showClientAppointments(Model model, Principal principal) {
        try {
            Client loggedInClient = getLoggedInClient(principal);
            List<Pet> pets = petService.getPetsByClient(loggedInClient);

            List<Appointment> clientAppointments = pets.stream()
                    .flatMap(pet -> appointmentService.getAllAppointments().stream()
                            .filter(appt -> appt.getPet() != null && appt.getPet().getPetID().equals(pet.getPetID())))
                    .collect(Collectors.toList());

            Set<Long> reviewedAppointmentIds = reviewService.getReviewedAppointmentIdsByClientId(loggedInClient.getClientId());

            model.addAttribute("appointments", convertToDtoList(clientAppointments));
            model.addAttribute("reviewedAppointmentIds", reviewedAppointmentIds);

            return "client/appointments";
        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", "Error loading appointments: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/appointments/book")
    public String showBookAppointmentForm(@RequestParam(value = "clinicId", required = false) Long preselectedClinicId,
                                          @RequestParam(value = "veterinaryId", required = false) Long preselectedVeterinaryId,
                                          Model model, Principal principal) {
        Client loggedInClient = getLoggedInClient(principal);
        model.addAttribute("pets", petService.getPetsByClient(loggedInClient));

        model.addAttribute("clinics", clinicService.getAllClinicsDto());

        model.addAttribute("today", LocalDate.now());

        if (preselectedClinicId != null) {
            model.addAttribute("preselectedClinicId", preselectedClinicId);
        }
        if (preselectedVeterinaryId != null) {
            model.addAttribute("preselectedVeterinaryId", preselectedVeterinaryId);
        }
        return "client/book_appointment";
    }

    @PostMapping("/appointments/book")
    public String bookAppointment(@RequestParam Integer petId, @RequestParam Long clinicId, @RequestParam Long veterinaryId, @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate appointmentDate, @RequestParam String appointmentTime, @RequestParam(required = false) String notes, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Client loggedInClient = getLoggedInClient(principal);
            Pet selectedPet = petService.getPetById(petId);
            if (selectedPet == null || !selectedPet.getClient().getClientId().equals(loggedInClient.getClientId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Selected pet is not valid or does not belong to you.");
                return "redirect:/api/clients/appointments/book";
            }
            Appointment newAppointment = new Appointment();
            newAppointment.setPet(selectedPet);
            newAppointment.setClinic(clinicService.getClinicById(clinicId));
            newAppointment.setVeterinary(veterinaryService.getVeterinaryEntityById(veterinaryId));
            newAppointment.setAppointmentDate(LocalDateTime.of(appointmentDate, LocalTime.parse(appointmentTime)));
            newAppointment.setStatus("Planned");
            appointmentService.createAppointment(newAppointment);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment booked successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
        }
        return "redirect:/api/clients/appointments";
    }

    @PostMapping("/appointments/cancel/{id}")
    public String cancelAppointment(@PathVariable("id") Long appointmentId, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Client loggedInClient = getLoggedInClient(principal);
            appointmentService.cancelAppointment(appointmentId, loggedInClient.getClientId());
            redirectAttributes.addFlashAttribute("successMessage", "Appointment cancelled successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error cancelling appointment: " + e.getMessage());
        }
        return "redirect:/api/clients/appointments";
    }

    @GetMapping("/appointments/{id}/review")
    public String showReviewForm(@PathVariable("id") Long appointmentId, Model model, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Client loggedInClient = getLoggedInClient(principal);
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null || !appointment.getPet().getClient().getClientId().equals(loggedInClient.getClientId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "You are not authorized to view this page.");
                return "redirect:/api/clients/appointments";
            }
            if (!"Completed".equalsIgnoreCase(appointment.getStatus())) {
                redirectAttributes.addFlashAttribute("errorMessage", "You can only review completed appointments.");
                return "redirect:/api/clients/appointments";
            }
            if (reviewService.getReviewedAppointmentIdsByClientId(loggedInClient.getClientId()).contains(appointmentId)) {
                redirectAttributes.addFlashAttribute("errorMessage", "This appointment has already been reviewed.");
                return "redirect:/api/clients/appointments";
            }
            model.addAttribute("appointment", appointment);
            return "client/leave_review";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An error occurred: " + e.getMessage());
            return "redirect:/api/clients/appointments";
        }
    }

    @PostMapping("/appointments/review/submit")
    public String submitReview(@RequestParam Long appointmentId, @RequestParam int rating, @RequestParam(required = false) String comment, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Client loggedInClient = getLoggedInClient(principal);
            reviewService.createReview(appointmentId, loggedInClient.getClientId(), rating, comment);
            redirectAttributes.addFlashAttribute("successMessage", "Thank you for your review!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error submitting review: " + e.getMessage());
        }
        return "redirect:/api/clients/appointments";
    }

    @GetMapping(value = "/veterinaries-by-clinic-and-date", produces = "application/json")
    @ResponseBody
    public List<VeterinaryDto> getVeterinariesByClinicAndDate(@RequestParam Long clinicId, @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

        List<Veterinary> vets = clinicVeterinaryRepository.findVeterinariesByClinicId(clinicId);
        return vets.stream().map(v -> new VeterinaryDto(v.getVeterinaryId(), v.getFirstName(), v.getLastName(), v.getSpecialization(), v.getUser() != null ? v.getUser().getUsername() : "N/A")).collect(Collectors.toList());
    }

    @GetMapping(value = "/appointments/available-slots", produces = "application/json")
    @ResponseBody
    public List<String> getAvailableSlotsForClient(@RequestParam Long clinicId, @RequestParam Long veterinaryId, @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            List<LocalDateTime> availableSlots = appointmentService.getAvailableTimeSlots(clinicId, veterinaryId, date);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            return availableSlots.stream().map(dateTime -> dateTime.format(timeFormatter)).collect(Collectors.toList());
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    @GetMapping(value = "/clinics/{clinicId}/veterinaries", produces = "application/json")
    @ResponseBody
    public List<VeterinaryDto> getVeterinariesForClinic(@PathVariable Long clinicId) {
        List<Veterinary> vets = clinicVeterinaryRepository.findVeterinariesByClinicId(clinicId);
        return vets.stream().map(v -> new VeterinaryDto(
                v.getVeterinaryId(), v.getFirstName(), v.getLastName(), v.getSpecialization(),
                v.getUser() != null ? v.getUser().getUsername() : "N/A"
        )).collect(Collectors.toList());
    }

    @GetMapping("/our-clinics")
    public String showOurClinics(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        model.addAttribute("clinics", clinicService.getAllClinicsDto());
        return "client/our_clinics";
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
            dto.setClientName(a.getPet() != null && a.getPet().getClient() != null ? a.getPet().getClient().getFirstName() + " " + a.getPet().getClient().getLastName() : "N/A");
            dto.setClinicName(a.getClinic() != null ? a.getClinic().getClinicName() : "N/A");
            dto.setVeterinaryName(a.getVeterinary() != null ?
                    a.getVeterinary().getFirstName() + " " + a.getVeterinary().getLastName() : "N/A");
            return dto;
        }).collect(Collectors.toList());
    }
    @GetMapping(value = "/clinics", produces = "application/json")
    @ResponseBody
    public List<ClinicDto> getClinicsByDistrictCode(@RequestParam("districtCode") Integer districtCode) {
        return clinicService.getClinicsByDistrictCode(districtCode);
    }

    @GetMapping(value = "/clinics/all", produces = "application/json")
    @ResponseBody
    public List<ClinicDto> getAllClinicsJson() {
        return clinicService.getAllClinicsDto();
    }


}