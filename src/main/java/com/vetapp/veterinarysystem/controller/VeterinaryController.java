package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.VeterinaryDto;
import com.vetapp.veterinarysystem.dto.AppointmentDTO;
import com.vetapp.veterinarysystem.model.Appointment;
import com.vetapp.veterinarysystem.model.Review; // Review modelini import et
import com.vetapp.veterinarysystem.service.ReviewService; // ReviewService'i import et
import com.vetapp.veterinarysystem.service.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.vetapp.veterinarysystem.model.*; // Appointment, Pet, Vaccination, VaccineType ekleyin
import com.vetapp.veterinarysystem.service.*; // AppointmentService, PetService, VaccinationService,
//import lombok.RequiredArgsConstructor; // Eğer kullanıyorsanız
import org.springframework.stereotype.Controller; // RestController yerine Controller kullanacağız JSP için
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.vetapp.veterinarysystem.repository.VeterinaryRepository;
import com.vetapp.veterinarysystem.model.Surgery;
import com.vetapp.veterinarysystem.model.SurgeryType;
import com.vetapp.veterinarysystem.service.SurgeryService;
import com.vetapp.veterinarysystem.service.SurgeryTypeService;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import org.springframework.transaction.annotation.Transactional; // BU IMPORT'U EKLEYİN


//@RestController //Eski
//@RequestMapping("/api/veterinaries") //Eski

@Controller // @RestController yerine @Controller
@RequestMapping("/veterinary") // API prefix'ini genel role prefix'i ile değiştirdim
//@RequiredArgsConstructor // Lombok kullanıyorsanız
public class VeterinaryController {

    private final VeterinaryService veterinaryService;
    private final AppointmentService appointmentService; // Eklendi
    private final PetService petService; // Eklendi
    private final VaccinationService vaccinationService; // Eklendi
    private final VaccineTypeService vaccineTypeService; // Eklendi
    private final SurgeryTypeService surgeryTypeService; // Eklendi
    private final SurgeryService surgeryService; // Eklendi
    private final VeterinaryRepository veterinaryRepository; // Eklendi
    private final UserService userService;
    private final ReviewService reviewService; // ReviewService'i ekle
    private final MedicalRecordService medicalRecordService;


    public VeterinaryController(VeterinaryService veterinaryService, AppointmentService appointmentService, PetService petService, VaccinationService vaccinationService, VaccineTypeService vaccineTypeService, SurgeryTypeService surgeryTypeService, SurgeryService surgeryService, VeterinaryRepository veterinaryRepository, UserService userService, ReviewService reviewService, MedicalRecordService medicalRecordService) {
        this.veterinaryService = veterinaryService;
        this.appointmentService = appointmentService;
        this.petService = petService;
        this.vaccinationService = vaccinationService;
        this.vaccineTypeService = vaccineTypeService;
        this.surgeryTypeService = surgeryTypeService;
        this.surgeryService = surgeryService;
        this.veterinaryRepository = veterinaryRepository;
        this.userService = userService;
        this.reviewService = reviewService;
        this.medicalRecordService = medicalRecordService;
    }

    /*
    // Create a new Veterinary
    @PostMapping
    public ResponseEntity<VeterinaryDto> createVeterinary(@RequestBody VeterinaryDto veterinaryDto) {
        VeterinaryDto createdVeterinary = veterinaryService.createVeterinary(veterinaryDto);
        return new ResponseEntity<>(createdVeterinary, HttpStatus.CREATED);
    }*/

    // Get Veterinary by ID eski
    //@GetMapping("/{id}")

    // Get Veterinary by ID
    @GetMapping("/api/{id}") // Örnek: Yolu değiştirdim
    @ResponseBody // JSON döndürmek için
    public ResponseEntity<VeterinaryDto> getVeterinaryById(@PathVariable Long id) {
        VeterinaryDto veterinaryDto = veterinaryService.getVeterinaryById(id);
        return new ResponseEntity<>(veterinaryDto, HttpStatus.OK);
    }

    /*
    // Get all Veterinaries
    @GetMapping
    public ResponseEntity<List<VeterinaryDto>> getAllVeterinaries() {
        List<VeterinaryDto> veterinaries = veterinaryService.getAllVeterinaries();
        return new ResponseEntity<>(veterinaries, HttpStatus.OK);
    }

    // Delete Veterinary by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVeterinary(@PathVariable Long id) {
        veterinaryService.deleteVeterinary(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

     */



    // --- AŞI YÖNETİMİ İÇİN YENİ METOTLAR ---
    /*
    @GetMapping("/appointments")
    public String listVeterinaryAppointments(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        String username = principal.getName();
        // TODO: Sadece bu veterinere ait randevuları getirin!
        // Örnek:
        // Veterinary vet = veterinaryService.getVeterinaryEntityByUserUsername(username); // Bu metodu VeterinaryService'e ekleyin
        // if (vet == null) {
        //     model.addAttribute("error", "Veterinary profile not found for user: " + username);
        //     return "error"; // Ya da uygun bir hata sayfası
        // }
        // List<Appointment> appointments = appointmentService.getAppointmentsByVeterinaryId(vet.getVeterinaryId());

        // GEÇİCİ OLARAK TÜM RANDEVULARI ALIYORUM, BUNU DÜZELTMENİZ GEREKİR!
        List<Appointment> appointments = appointmentService.getAllAppointments();

        model.addAttribute("appointments", appointments);
        return "veterinary/appointments"; // veterinary/appointments.jsp
    }*/


    @GetMapping("/appointments/{appointmentId}/vaccinations")
    public String manageAppointmentVaccinations(@PathVariable Long appointmentId, Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        if (appointment == null) {
            model.addAttribute("error_message", "Appointment not found."); // JSP'de göstermek için
            return "redirect:/veterinary/appointments?error=AppointmentNotFound";
        }

        // TODO: Güvenlik kontrolü - Bu veteriner bu randevuya erişebilir mi?
        // Örneğin, randevunun veterineri, giriş yapan veteriner mi?
        // Veterinary currentVeterinary = veterinaryService.getVeterinaryEntityByUserUsername(principal.getName());
        // if (currentVeterinary == null || !appointment.getVeterinary().getVeterinaryId().equals(currentVeterinary.getVeterinaryId())) {
        //     model.addAttribute("error_message", "You are not authorized to manage vaccinations for this appointment.");
        //     return "redirect:/veterinary/appointments?error=Unauthorized";
        // }

        Pet pet = appointment.getPet();
        if (pet == null) {
            model.addAttribute("error_message", "Pet not found for this appointment.");
            return "redirect:/veterinary/appointments?error=PetNotFound";
        }

        List<Vaccination> existingVaccinations = vaccinationService.getVaccinationsByPetId(pet.getPetID());
        List<VaccineType> allVaccineTypes = vaccineTypeService.getAllVaccineTypes();

        model.addAttribute("appointment", appointment);
        // Ayrıca formatlanmış tarihi de ekleyelim
        if (appointment.getAppointmentDate() != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
            model.addAttribute("formattedAppointmentDate", appointment.getAppointmentDate().format(formatter));
        } else {
            model.addAttribute("formattedAppointmentDate", "N/A");
        }
        model.addAttribute("pet", pet);
        model.addAttribute("existingVaccinations", existingVaccinations);
        model.addAttribute("allVaccineTypes", allVaccineTypes);
        model.addAttribute("newVaccination", new Vaccination());

        return "veterinary/manage_appointment_vaccinations";
    }

    @PostMapping("/appointments/{appointmentId}/vaccinations/add")
    public String addVaccinationToAppointment(@PathVariable Long appointmentId,
                                              @RequestParam Long vaccineTypeId,
                                              @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateAdministered,
                                              @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate nextDueDate,
                                              Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) {
            return "redirect:/login";
        }

        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        if (appointment == null || appointment.getPet() == null) {
            redirectAttributes.addFlashAttribute("error", "Appointment or Pet not found.");
            return "redirect:/veterinary/appointments"; // Genel randevu listesine yönlendir
        }

        // TODO: Güvenlik kontrolü (yukarıdaki gibi)

        Pet pet = appointment.getPet();
        VaccineType vaccineType = vaccineTypeService.getVaccineTypeById(vaccineTypeId);

        if (vaccineType == null) {
            redirectAttributes.addFlashAttribute("error", "Vaccine Type not found.");
            return "redirect:/veterinary/appointments/" + appointmentId + "/vaccinations";
        }

        Vaccination newVaccination = new Vaccination();
        newVaccination.setPet(pet);
        newVaccination.setVaccineType(vaccineType);
        newVaccination.setDateAdministered(dateAdministered);
        newVaccination.setNextDueDate(nextDueDate);

        vaccinationService.saveVaccination(newVaccination);
        redirectAttributes.addFlashAttribute("success", "Vaccination added successfully.");
        return "redirect:/veterinary/appointments/" + appointmentId + "/vaccinations";
    }

    @PostMapping("/appointments/{appointmentId}/vaccinations/delete/{vaccinationId}")
    public String deleteVaccinationFromAppointment(@PathVariable Long appointmentId,
                                                   @PathVariable Long vaccinationId,
                                                   Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) {
            return "redirect:/login";
        }

        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        Vaccination vaccination = vaccinationService.getVaccinationById(vaccinationId);

        if (appointment == null) {
            redirectAttributes.addFlashAttribute("error", "Appointment not found.");
            return "redirect:/veterinary/appointments";
        }
        if (vaccination == null) {
            redirectAttributes.addFlashAttribute("error", "Vaccination record not found.");
            return "redirect:/veterinary/appointments/" + appointmentId + "/vaccinations";
        }
        if (appointment.getPet() == null || !vaccination.getPet().getPetID().equals(appointment.getPet().getPetID())) {
            redirectAttributes.addFlashAttribute("error", "Vaccination does not belong to the pet in this appointment.");
            return "redirect:/veterinary/appointments/" + appointmentId + "/vaccinations";
        }

        // TODO: Güvenlik kontrolü (yukarıdaki gibi)

        vaccinationService.deleteVaccination(vaccinationId);
        redirectAttributes.addFlashAttribute("success", "Vaccination deleted successfully.");
        return "redirect:/veterinary/appointments/" + appointmentId + "/vaccinations";
    }




    // --- AMELİYAT YÖNETİMİ İÇİN YENİ METOTLAR ---

    @GetMapping("/appointments/{appointmentId}/surgeries")
    public String manageAppointmentSurgeries(@PathVariable Long appointmentId, Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        if (appointment == null) {
            model.addAttribute("error_message", "Appointment not found.");
            return "redirect:/veterinary/appointments?error=AppointmentNotFound";
        }

        Pet pet = appointment.getPet();
        if (pet == null) {
            model.addAttribute("error_message", "Pet not found for this appointment.");
            return "redirect:/veterinary/appointments?error=PetNotFound";
        }

        // Giriş yapmış veterineri al
        Veterinary loggedInVeterinary = veterinaryRepository.findByUserUsername(principal.getName())
                .orElseThrow(() -> new RuntimeException("Veterinary user not found: " + principal.getName()));

        // TODO: Güvenlik kontrolü - Bu veteriner bu randevuya/pete ait ameliyatları yönetebilir mi?

        List<Surgery> existingSurgeries = surgeryService.getSurgeriesByPetId(pet.getPetID());
        List<SurgeryType> allSurgeryTypes = surgeryTypeService.getAllSurgeryTypes();

        model.addAttribute("appointment", appointment);
        model.addAttribute("pet", pet);
        model.addAttribute("loggedInVeterinary", loggedInVeterinary); // Ameliyatı yapan veteriner için
        model.addAttribute("existingSurgeries", existingSurgeries);
        model.addAttribute("allSurgeryTypes", allSurgeryTypes);
        model.addAttribute("newSurgery", new Surgery()); // Form için boş obje

        // Appointment tarihini formatlayıp modele ekleyelim (JSP'de kullanmak için)
        if (appointment.getAppointmentDate() != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
            model.addAttribute("formattedAppointmentDate", appointment.getAppointmentDate().format(formatter));
        } else {
            model.addAttribute("formattedAppointmentDate", "N/A");
        }


        return "veterinary/manage_appointment_surgeries"; // Yeni JSP sayfamız
    }

    @PostMapping("/appointments/{appointmentId}/surgeries/add")
    public String addSurgeryToAppointment(@PathVariable Long appointmentId,
                                          @RequestParam Long surgeryTypeId,
                                          @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate surgeryDate,
                                          @RequestParam(required = false) String notes,
                                          Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) {
            return "redirect:/login";
        }

        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        if (appointment == null || appointment.getPet() == null) {
            redirectAttributes.addFlashAttribute("error", "Appointment or Pet not found.");
            return "redirect:/veterinary/appointments";
        }

        Pet pet = appointment.getPet();
        SurgeryType surgeryType = surgeryTypeService.getSurgeryTypeById(surgeryTypeId);
        Veterinary performingVeterinary = veterinaryRepository.findByUserUsername(principal.getName())
                .orElseThrow(() -> new RuntimeException("Veterinary user not found: " + principal.getName()));


        if (surgeryType == null) {
            redirectAttributes.addFlashAttribute("error", "Surgery Type not found.");
            return "redirect:/veterinary/appointments/" + appointmentId + "/surgeries";
        }

        Surgery newSurgery = new Surgery();
        newSurgery.setPet(pet);
        newSurgery.setVeterinary(performingVeterinary); // Ameliyatı yapan veteriner
        newSurgery.setSurgeryType(surgeryType);
        newSurgery.setDate(surgeryDate);
        newSurgery.setNotes(notes);
        // newSurgery.setMedicalRecord(...); // Eğer tıbbi kayda bağlanacaksa

        surgeryService.saveSurgery(newSurgery);
        redirectAttributes.addFlashAttribute("success", "Surgery added successfully.");
        return "redirect:/veterinary/appointments/" + appointmentId + "/surgeries";
    }

    @PostMapping("/appointments/{appointmentId}/surgeries/delete/{surgeryId}")
    public String deleteSurgeryFromAppointment(@PathVariable Long appointmentId,
                                               @PathVariable Long surgeryId,
                                               Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) {
            return "redirect:/login";
        }

        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        Surgery surgery = surgeryService.getSurgeryById(surgeryId);

        if (appointment == null) {
            redirectAttributes.addFlashAttribute("error", "Appointment not found.");
            return "redirect:/veterinary/appointments";
        }
        if (surgery == null) {
            redirectAttributes.addFlashAttribute("error", "Surgery record not found.");
            return "redirect:/veterinary/appointments/" + appointmentId + "/surgeries";
        }
        // Güvenlik: Bu ameliyat bu randevunun pet'ine mi ait? Ya da bu veteriner silebilir mi?
        if (appointment.getPet() == null || !surgery.getPet().getPetID().equals(appointment.getPet().getPetID())) {
            redirectAttributes.addFlashAttribute("error", "Surgery does not belong to the pet in this appointment.");
            return "redirect:/veterinary/appointments/" + appointmentId + "/surgeries";
        }
        // İsteğe bağlı: Sadece ameliyatı yapan veterinerin silebilmesi için ek kontrol
        // Veterinary loggedInVeterinary = veterinaryRepository.findByUserUsername(principal.getName()).orElse(null);
        // if (loggedInVeterinary == null || !surgery.getVeterinary().getVeterinaryId().equals(loggedInVeterinary.getVeterinaryId())) {
        //    redirectAttributes.addFlashAttribute("error", "You are not authorized to delete this surgery record.");
        //    return "redirect:/veterinary/appointments/" + appointmentId + "/surgeries";
        // }


        surgeryService.deleteSurgery(surgeryId);
        redirectAttributes.addFlashAttribute("success", "Surgery deleted successfully.");
        return "redirect:/veterinary/appointments/" + appointmentId + "/surgeries";
    }



    /**
     * Randevu durumu güncelleme formunu gösterir. (GET)
     */
    @GetMapping("/appointments/update-status/{id}")
    public String showUpdateStatusForm(@PathVariable Long id, Model model) {
        Appointment appointment = appointmentService.getAppointmentById(id);
        if (appointment == null) {
            return "redirect:/veterinary/appointments";
        }

        List<String> statuses = Arrays.asList("Scheduled", "Completed", "Canceled", "No-Show");
        model.addAttribute("appointment", appointment);
        model.addAttribute("statuses", statuses);

        return "veterinary/update_appointment_status";
    }

    /**
     * Randevu durumunu günceller. (POST)
     */
    @PostMapping("/appointments/update-status")
    public String updateAppointmentStatus(@RequestParam Long appointmentId,
                                          @RequestParam String status,
                                          RedirectAttributes redirectAttributes) {
        try {
            appointmentService.updateAppointmentStatus(appointmentId, status);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment status updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating status: " + e.getMessage());
        }
        return "redirect:/veterinary/appointments";
    }



    // YENİ METOT: Veterinerin yorumlarını listeleyen sayfa
    @GetMapping("/reviews")
    @Transactional(readOnly = true) // BU ANOTASYONU EKLEYİN
    public String showMyReviews(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        // Giriş yapmış veterineri bul
        Optional<Veterinary> veterinaryOpt = veterinaryService.getAllVeterinaryEntities().stream()
                .filter(v -> v.getUser().getUsername().equals(principal.getName()))
                .findFirst();

        if (veterinaryOpt.isEmpty()) {
            model.addAttribute("errorMessage", "Veterinary profile not found.");
            return "error";
        }

        // 1. Servisten veriyi al (Bu aşamada ilişkili veriler LAZY durumda olabilir)
        List<Review> reviews = reviewService.getReviewsByVeterinaryId(veterinaryOpt.get().getVeterinaryId());

        // 2. İhtiyaç duyulan LAZY verileri manuel olarak tetikle
        // Bu döngü, JSP'ye gitmeden ÖNCE çalışarak gerekli verilerin yüklenmesini sağlar.
        // Aslında sadece bir "get" işlemi yapmak bile yeterlidir.
        reviews.forEach(review -> {
            // review.getAppointment().getPet().getClient().getFirstName(); // Bu satır tek başına yeterli
            // Daha okunabilir olması için:
            if (review.getAppointment() != null && review.getAppointment().getPet() != null) {
                // Sadece client'e erişmek bile client proxy'sini yükler.
                review.getAppointment().getPet().getClient().getFirstName();
            }
        });

        model.addAttribute("reviews", reviews); // Artık 'reviews' listesindeki proxy'ler dolu.

        // Ortalama puanı hesapla ve modele ekle
        double averageRating = reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
        model.addAttribute("averageRating", String.format("%.1f", averageRating));
        model.addAttribute("totalReviews", reviews.size());

        return "veterinary/my_reviews";
    }





    //MEDICAL RECORDS

    @GetMapping("/appointments/{appointmentId}/medical-records")
    public String manageMedicalRecords(@PathVariable Long appointmentId, Model model, RedirectAttributes redirectAttributes) {
        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        if (appointment == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Appointment not found.");
            return "redirect:/veterinary/appointments";
        }

        List<MedicalRecord> records = medicalRecordService.getMedicalRecordsByPetId(appointment.getPet().getPetID());

        model.addAttribute("appointment", appointment);
        model.addAttribute("records", records);
        model.addAttribute("newRecord", new MedicalRecord());
        // Bu, oluşturulacak yeni JSP sayfasıdır.
        return "veterinary/manage_appointment_medical_records";
    }

    @PostMapping("/appointments/medical-records/add")
    public String addMedicalRecord(@RequestParam Long appointmentId,
                                   @RequestParam String description, // Diagnosis alanı
                                   @RequestParam String treatment,
                                   @RequestParam("date") String date, // RecordDate alanı
                                   RedirectAttributes redirectAttributes) {
        try {
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            MedicalRecord newRecord = new MedicalRecord();
            newRecord.setPet(appointment.getPet());
            newRecord.setVeterinary(appointment.getVeterinary());
            newRecord.setDescription(description);
            newRecord.setTreatment(treatment);
            newRecord.setDate(LocalDate.parse(date));

            medicalRecordService.saveMedicalRecord(newRecord);
            redirectAttributes.addFlashAttribute("successMessage", "Medical record added successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding medical record: " + e.getMessage());
        }

        return "redirect:/veterinary/appointments/" + appointmentId + "/medical-records";
    }

    @PostMapping("/appointments/medical-records/delete/{recordId}")
    public String deleteMedicalRecord(@PathVariable Long recordId, @RequestParam Long appointmentId, RedirectAttributes redirectAttributes) {
        try {
            medicalRecordService.deleteMedicalRecord(recordId);
            redirectAttributes.addFlashAttribute("successMessage", "Medical record deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting medical record: " + e.getMessage());
        }
        return "redirect:/veterinary/appointments/" + appointmentId + "/medical-records";
    }


}
