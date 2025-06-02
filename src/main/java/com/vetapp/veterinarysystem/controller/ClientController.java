// src/main/java/com/vetapp/veterinarysystem/controller/ClientController.java
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
import java.time.LocalDateTime; // LocalDateTime ekleyin
import java.time.LocalTime; // LocalTime ekleyin
import java.time.format.DateTimeFormatter; // DateTimeFormatter ekleyin
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors; // Collectors ekleyin

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


    // Helper metot: Giriş yapmış client'ı bulur
    private Client getLoggedInClient(Principal principal) {
        if (principal == null) {
            throw new IllegalStateException("User not authenticated.");
        }
        String username = principal.getName();
        return clientRepository.findByUserUsername(username)
                .orElseThrow(() -> new RuntimeException("Client user not found: " + username + ". Ensure a Client record is linked to this user."));
    }

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

    @GetMapping("/account-settings")
    public String showAccountSettings(Model model, Principal principal) {
        System.out.println("Account settings çağrıldı, principal: " + principal);
        if (principal == null) return "redirect:/login";
        try {
            String username = principal.getName();
            ClientAccountSettingsDto dto = clientService.getAccountSettings(username);
            model.addAttribute("accountSettings", dto);
            return "client/account_settings";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Hesap bilgileri yüklenemedi: " + e.getMessage());
            return "error/custom_error";
        }
    }



    @PostMapping("/account-settings")
    public String updateAccountSettings(
            @ModelAttribute("accountSettings") ClientAccountSettingsDto dto,
            Principal principal, Model model) {
        if (principal == null) return "redirect:/login";
        String username = principal.getName();
        clientService.updateAccountSettings(username, dto);
        model.addAttribute("accountSettings", dto);
        model.addAttribute("success", true);
        return "client/account_settings";
    }


    @GetMapping("/change-password")
    public String showChangePassword(Model model) {
        model.addAttribute("passwordChange", new PasswordChangeDto());
        return "client/change_password";
    }


    @PostMapping("/change-password")
    public String processChangePassword(@ModelAttribute("passwordChange") PasswordChangeDto dto,
                                        Principal principal, Model model) {
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


    // CLIENT RANDEVU YÖNETİMİ
    @GetMapping("/appointments")
    public String showClientAppointments(Model model, Principal principal) {
        try {
            Client loggedInClient = getLoggedInClient(principal);
            List<Pet> pets = petService.getPetsByClient(loggedInClient); // Client'a ait tüm petleri al

            // Bu pet'lere ait tüm randevuları topla
            List<Appointment> clientAppointments = pets.stream()
                    .flatMap(pet -> appointmentService.getAllAppointments().stream() // Tüm randevuları çekip filtrele
                            .filter(appt -> appt.getPet() != null && appt.getPet().getPetID().equals(pet.getPetID())))
                    .collect(Collectors.toList());

            model.addAttribute("appointments", convertToDtoList(clientAppointments));
            return "client/appointments";
        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", "Error loading appointments: " + e.getMessage());
            return "error/custom_error"; // Veya daha uygun bir hata sayfası
        }
    }

    @GetMapping("/appointments/book")
    public String showBookAppointmentForm(Model model, Principal principal) {
        Client loggedInClient = getLoggedInClient(principal);

        model.addAttribute("pets", petService.getPetsByClient(loggedInClient));
        model.addAttribute("clinics", clinicService.getAllClinics());
        // Veterinaries will be loaded dynamically via AJAX based on selected clinic
        model.addAttribute("today", LocalDate.now()); // Set today's date for minimum date in date picker

        return "client/book_appointment";
    }

    @PostMapping("/appointments/book")
    public String bookAppointment(@RequestParam Integer petId,
                                  @RequestParam Long clinicId,
                                  @RequestParam Long veterinaryId,
                                  @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate appointmentDate,
                                  @RequestParam String appointmentTime, // HH:mm formatında gelecek
                                  @RequestParam(required = false) String notes,
                                  Principal principal,
                                  RedirectAttributes redirectAttributes) {
        try {
            Client loggedInClient = getLoggedInClient(principal);

            // Gelen petId'nin gerçekten bu client'a ait olup olmadığını kontrol et
            Pet selectedPet = petService.getPetById(petId);
            if (selectedPet == null || !selectedPet.getClient().getClientId().equals(loggedInClient.getClientId())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Selected pet is not valid or does not belong to you.");
                return "redirect:/api/clients/appointments/book";
            }

            Clinic selectedClinic = clinicService.getClinicById(clinicId);
            Veterinary selectedVeterinary = veterinaryService.getVeterinaryEntityById(veterinaryId);

            // Tarih ve saati birleştir
            LocalDateTime fullAppointmentDateTime = LocalDateTime.of(appointmentDate, LocalTime.parse(appointmentTime));

            Appointment newAppointment = new Appointment();
            newAppointment.setPet(selectedPet);
            newAppointment.setClinic(selectedClinic);
            newAppointment.setVeterinary(selectedVeterinary);
            newAppointment.setAppointmentDate(fullAppointmentDateTime);
            newAppointment.setStatus("Planned"); // Müşteri tarafından oluşturulan randevular "Planned" statüsünde başlar

            appointmentService.createAppointment(newAppointment);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment booked successfully!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error booking appointment: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
        }
        return "redirect:/api/clients/appointments";
    }

    // Randevu iptali endpoint'i
    @PostMapping("/appointments/cancel/{id}")
    public String cancelAppointment(@PathVariable("id") Long appointmentId, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Client loggedInClient = getLoggedInClient(principal);
            appointmentService.cancelAppointment(appointmentId, loggedInClient.getClientId());
            redirectAttributes.addFlashAttribute("successMessage", "Appointment cancelled successfully!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error cancelling appointment: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An unexpected error occurred during cancellation: " + e.getMessage());
            e.printStackTrace(); // Hata ayıklama için konsola yazdırın
        }
        return "redirect:/api/clients/appointments";
    }


    // AJAX endpoint for fetching veterinaries by clinic (used in booking form)
    @GetMapping(value = "/veterinaries-by-clinic-and-date", produces = "application/json")
    @ResponseBody
    public List<VeterinaryDto> getVeterinariesByClinicAndDate(@RequestParam Long clinicId,
                                                              @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        // Bu metod, klinik ve tarihe göre müsait veterinerleri döndürebilir.
        // Ancak AppointmentService.getAvailableTimeSlots zaten veteriner ID'si bekliyor.
        // Basitlik için şimdilik sadece kliniğe atanmış tüm veterinerleri döndürelim.
        // Gerçek bir senaryoda, müsaitlik kontrolü burada daha karmaşık olabilir.
        List<Veterinary> vets = clinicVeterinaryRepository.findVeterinariesByClinicId(clinicId);
        return vets.stream().map(v -> new VeterinaryDto(
                v.getVeterinaryId(), v.getFirstName(), v.getLastName(), v.getSpecialization(),
                v.getUser() != null ? v.getUser().getUsername() : "N/A"
        )).collect(Collectors.toList());
    }

    @GetMapping(value = "/appointments/available-slots", produces = "application/json")
    @ResponseBody
    public List<String> getAvailableSlotsForClient(@RequestParam Long clinicId,
                                                   @RequestParam Long veterinaryId,
                                                   @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            List<LocalDateTime> availableSlots = appointmentService.getAvailableTimeSlots(clinicId, veterinaryId, date);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            return availableSlots.stream()
                    .map(dateTime -> dateTime.format(timeFormatter))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error fetching available slots for client: " + e.getMessage());
            return Collections.emptyList();
        }
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
                    a.getVeterinary().getFirstName() + " " + a.getVeterinary().getLastName() : "N/A"); // Bu satır düzeltildi
            return dto;
        }).collect(Collectors.toList());
    }
}
