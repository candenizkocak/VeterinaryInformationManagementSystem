package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.model.*;
import com.vetapp.veterinarysystem.repository.AppointmentRepository;
import com.vetapp.veterinarysystem.repository.ClinicVeterinaryRepository;
import com.vetapp.veterinarysystem.repository.PetRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;
import com.vetapp.veterinarysystem.model.ItemType;
import com.vetapp.veterinarysystem.model.Supplier;

@Controller
@RequestMapping("/clinic")
@RequiredArgsConstructor
public class ClinicController {

    private final ClinicService clinicService;
    private final VeterinaryService veterinaryService;
    private final ClinicVeterinaryRepository clinicVeterinaryRepository;
    private final AppointmentService appointmentService;
    private final PetService petService;
    private final ClientService clientService; // To retrieve client details for pets
    private final VaccineTypeService vaccineTypeService;
    private final InventoryService inventoryService;
    private final ItemTypeService itemTypeService;
    private final SupplierService supplierService;
    private final UserRepository userRepository; // For finding clinic by user

    // Helper method to get the logged-in clinic
    private Clinic getCurrentClinic(Principal principal) {
        if (principal == null) {
            throw new IllegalStateException("User not authenticated.");
        }
        String username = principal.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found: " + username));
        // Assuming there's a findByUser method in ClinicRepository or filter as below
        return clinicService.getAllClinics().stream()
                .filter(clinic -> clinic.getUser() != null && clinic.getUser().getUserID() == user.getUserID())
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Clinic not found for logged-in user."));
    }

    @GetMapping("/dashboard")
    public String clinicDashboard(Model model, Principal principal) {
        Clinic clinic = getCurrentClinic(principal);
        model.addAttribute("clinic", clinic);
        return "clinic/dashboard"; // Create a simple clinic dashboard JSP
    }

    // --- Veterinarian Management (CRUD) ---
    @GetMapping("/veterinaries")
    public String listClinicVeterinaries(Model model, Principal principal) {
        Clinic clinic = getCurrentClinic(principal);
        List<Veterinary> assignedVeterinaries = clinicVeterinaryRepository.findVeterinariesByClinicId(clinic.getClinicId());
        List<Veterinary> allVeterinaries = veterinaryService.getAllVeterinaryEntities();

        // Filter out already assigned veterinarians from the 'allVeterinaries' list
        List<Long> assignedVetIds = assignedVeterinaries.stream()
                .map(Veterinary::getVeterinaryId)
                .collect(Collectors.toList());
        List<Veterinary> unassignedVeterinaries = allVeterinaries.stream()
                .filter(vet -> !assignedVetIds.contains(vet.getVeterinaryId()))
                .collect(Collectors.toList());

        model.addAttribute("clinic", clinic);
        model.addAttribute("assignedVeterinaries", assignedVeterinaries);
        model.addAttribute("unassignedVeterinaries", unassignedVeterinaries); // For adding new vets
        return "clinic/veterinaries";
    }

    @PostMapping("/veterinaries/assign")
    public String assignVeterinaryToClinic(@RequestParam Long veterinaryId, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Clinic clinic = getCurrentClinic(principal);
            Veterinary vet = veterinaryService.getVeterinaryEntityById(veterinaryId);

            // Check if already assigned
            boolean alreadyAssigned = clinicVeterinaryRepository.findByClinic(clinic).stream()
                    .anyMatch(cv -> cv.getVeterinary().getVeterinaryId().equals(veterinaryId));

            if (alreadyAssigned) {
                redirectAttributes.addFlashAttribute("error", "Veterinary is already assigned to this clinic.");
            } else {
                ClinicVeterinary relation = ClinicVeterinary.builder()
                        .clinic(clinic)
                        .veterinary(vet)
                        .build();
                clinicVeterinaryRepository.save(relation);
                redirectAttributes.addFlashAttribute("success", "Veterinary assigned successfully!");
            }
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/clinic/veterinaries";
    }

    @PostMapping("/veterinaries/remove/{veterinaryId}")
    public String removeVeterinaryFromClinic(@PathVariable Long veterinaryId, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Clinic clinic = getCurrentClinic(principal);
            Veterinary vet = veterinaryService.getVeterinaryEntityById(veterinaryId);
            clinicVeterinaryRepository.deleteByClinicAndVeterinary(clinic, vet);
            redirectAttributes.addFlashAttribute("success", "Veterinary removed successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/clinic/veterinaries";
    }

    // --- Appointment Management (View and Approve) ---
    @GetMapping("/appointments")
    public String listClinicAppointments(Model model, Principal principal) {
        Clinic clinic = getCurrentClinic(principal);
        List<Appointment> appointments = appointmentService.getAllAppointments().stream()
                .filter(appt -> appt.getClinic() != null && appt.getClinic().getClinicId().equals(clinic.getClinicId()))
                .collect(Collectors.toList());
        model.addAttribute("appointments", appointments);
        return "clinic/appointments";
    }

    @PostMapping("/appointments/approve/{id}")
    public String approveAppointment(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Clinic clinic = getCurrentClinic(principal);
            Appointment appointment = appointmentService.getAppointmentById(id);

            if (appointment == null) {
                redirectAttributes.addFlashAttribute("error", "Appointment not found.");
                return "redirect:/clinic/appointments";
            }
            if (!appointment.getClinic().getClinicId().equals(clinic.getClinicId())) {
                redirectAttributes.addFlashAttribute("error", "You do not have permission to approve this appointment.");
                return "redirect:/clinic/appointments";
            }

            appointment.setStatus("Approved");
            appointmentService.updateAppointment(id, appointment);
            redirectAttributes.addFlashAttribute("success", "Appointment approved successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/clinic/appointments";
    }

    // --- Clients and their Animals ---
    @GetMapping("/clients-and-pets")
    public String viewClinicClientsAndPets(Model model, Principal principal) {
        Clinic clinic = getCurrentClinic(principal);
        List<Pet> clinicPets = petService.getPetsByClinicId(Math.toIntExact(clinic.getClinicId())); // Updated method signature

        // Collect unique clients from these pets
        List<Client> clients = clinicPets.stream()
                .map(Pet::getClient)
                .distinct()
                .collect(Collectors.toList());

        model.addAttribute("clinic", clinic);
        model.addAttribute("clients", clients);
        model.addAttribute("clinicPets", clinicPets); // Can also pass this to make it easier to show pets per client
        return "clinic/clients_and_pets";
    }
    // --- Item Type Management ---
    @GetMapping("/item-types")
    public String manageItemTypes(Model model, Principal principal) {
        getCurrentClinic(principal); // Auth check
        model.addAttribute("itemTypes", itemTypeService.getAllItemTypes());
        model.addAttribute("newItemType", new ItemType()); // For add form
        return "clinic/item_types";
    }

    @PostMapping("/item-types/add")
    public String addItemType(@ModelAttribute ItemType itemType, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            getCurrentClinic(principal); // Auth check
            itemTypeService.createItemType(itemType);
            redirectAttributes.addFlashAttribute("success", "Item type added successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error adding item type: " + e.getMessage());
            e.printStackTrace(); // For debugging
        }
        return "redirect:/clinic/item-types";
    }

    @PostMapping("/item-types/delete/{id}")
    public String deleteItemType(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            getCurrentClinic(principal); // Auth check
            itemTypeService.deleteItemType(id);
            redirectAttributes.addFlashAttribute("success", "Item type deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting item type: " + e.getMessage());
            e.printStackTrace(); // For debugging
        }
        return "redirect:/clinic/item-types";
    }

    @GetMapping("/suppliers")
    public String manageSuppliers(Model model, Principal principal) {
        getCurrentClinic(principal); // Auth check
        model.addAttribute("suppliers", supplierService.getAllSuppliers());
        model.addAttribute("newSupplier", new Supplier()); // For add form
        return "clinic/suppliers";
    }

    @PostMapping("/suppliers/add")
    public String addSupplier(@ModelAttribute Supplier supplier, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            getCurrentClinic(principal); // Auth check
            supplierService.createSupplier(supplier);
            redirectAttributes.addFlashAttribute("success", "Supplier added successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error adding supplier: " + e.getMessage());
            e.printStackTrace(); // For debugging
        }
        return "redirect:/clinic/suppliers";
    }

    @PostMapping("/suppliers/delete/{id}")
    public String deleteSupplier(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            getCurrentClinic(principal); // Auth check
            supplierService.deleteSupplier(id);
            redirectAttributes.addFlashAttribute("success", "Supplier deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting supplier: " + e.getMessage());
            e.printStackTrace(); // For debugging
        }
        return "redirect:/clinic/suppliers";
    }

    // --- Vaccine Types Management (Add/Delete) ---
    @GetMapping("/vaccine-types")
    public String manageVaccineTypes(Model model, Principal principal) {
        getCurrentClinic(principal); // Just to ensure clinic user is logged in
        model.addAttribute("vaccineTypes", vaccineTypeService.getAllVaccineTypes());
        model.addAttribute("newVaccineType", new VaccineType()); // For add form
        return "clinic/vaccine_types";
    }

    @PostMapping("/vaccine-types/add")
    public String addVaccineType(@ModelAttribute VaccineType vaccineType, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            getCurrentClinic(principal);
            vaccineTypeService.createVaccineType(vaccineType);
            redirectAttributes.addFlashAttribute("success", "Vaccine type added successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error adding vaccine type: " + e.getMessage());
        }
        return "redirect:/clinic/vaccine-types";
    }

    @PostMapping("/vaccine-types/delete/{id}")
    public String deleteVaccineType(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            getCurrentClinic(principal);
            vaccineTypeService.deleteVaccineType(id);
            redirectAttributes.addFlashAttribute("success", "Vaccine type deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting vaccine type: " + e.getMessage());
        }
        return "redirect:/clinic/vaccine-types";
    }

    // --- Inventory Management (CRUD) ---
    @GetMapping("/inventory")
    public String manageInventory(Model model, Principal principal) {
        Clinic clinic = getCurrentClinic(principal);
        List<Inventory> inventoryItems = inventoryService.getInventoryByClinicId(clinic.getClinicId());
        model.addAttribute("clinic", clinic);
        model.addAttribute("inventoryItems", inventoryItems);
        model.addAttribute("itemTypes", itemTypeService.getAllItemTypes());
        model.addAttribute("suppliers", supplierService.getAllSuppliers());
        model.addAttribute("newItem", new Inventory()); // For add form
        return "clinic/inventory";
    }

    @PostMapping("/inventory/add")
    public String addInventoryItem(@ModelAttribute Inventory inventoryItem, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Clinic clinic = getCurrentClinic(principal);
            inventoryItem.setClinic(clinic); // Ensure item is linked to the current clinic
            inventoryService.createInventoryItem(inventoryItem);
            redirectAttributes.addFlashAttribute("success", "Inventory item added successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error adding inventory item: " + e.getMessage());
        }
        return "redirect:/clinic/inventory";
    }

    @PostMapping("/inventory/update/{id}")
    public String updateInventoryItem(@PathVariable Long id, @ModelAttribute Inventory inventoryItem, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Clinic clinic = getCurrentClinic(principal);
            Inventory existingItem = inventoryService.getInventoryItemById(id);

            if (!existingItem.getClinic().getClinicId().equals(clinic.getClinicId())) {
                redirectAttributes.addFlashAttribute("error", "You do not have permission to update this inventory item.");
                return "redirect:/clinic/inventory";
            }
            inventoryItem.setItemId(id); // Ensure ID is set for update
            inventoryItem.setClinic(clinic); // Ensure item is linked to the current clinic
            inventoryService.updateInventoryItem(inventoryItem);
            redirectAttributes.addFlashAttribute("success", "Inventory item updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating inventory item: " + e.getMessage());
        }
        return "redirect:/clinic/inventory";
    }

    @PostMapping("/inventory/update/")
    public String updateInventoryItemWithoutId(Principal principal, RedirectAttributes redirectAttributes) {
        // Handle the case where no ID is provided
        redirectAttributes.addFlashAttribute("error", "No inventory item ID was provided for update. Please try again.");
        return "redirect:/clinic/inventory";
    }

    @PostMapping("/inventory/delete/{id}")
    public String deleteInventoryItem(@PathVariable Long id, Principal principal, RedirectAttributes redirectAttributes) {
        try {
            Clinic clinic = getCurrentClinic(principal);
            Inventory itemToDelete = inventoryService.getInventoryItemById(id);

            if (!itemToDelete.getClinic().getClinicId().equals(clinic.getClinicId())) {
                redirectAttributes.addFlashAttribute("error", "You do not have permission to delete this inventory item.");
                return "redirect:/clinic/inventory";
            }
            inventoryService.deleteInventoryItem(id);
            redirectAttributes.addFlashAttribute("success", "Inventory item deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting inventory item: " + e.getMessage());
        }
        return "redirect:/clinic/inventory";
    }
}

