package com.vetapp.veterinarysystem.controller.admin;

import com.vetapp.veterinarysystem.model.MedicalRecord;
import com.vetapp.veterinarysystem.service.MedicalRecordService;
import com.vetapp.veterinarysystem.service.PetService;
import com.vetapp.veterinarysystem.service.VeterinaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/medical-records")
@RequiredArgsConstructor
public class AdminMedicalRecordController {

    private final MedicalRecordService medicalRecordService;
    private final PetService petService;
    private final VeterinaryService veterinaryService;

    @GetMapping
    public String listAllMedicalRecords(Model model) {
        List<MedicalRecord> records = medicalRecordService.getAllMedicalRecords();
        model.addAttribute("records", records);
        return "admin/medical_records";
    }

    @GetMapping("/pet/{petId}")
    public String listMedicalRecordsByPet(@PathVariable Long petId, Model model) {
        List<MedicalRecord> records = medicalRecordService.getMedicalRecordsByPetId(petId);
        model.addAttribute("records", records);
        model.addAttribute("pet", petService.getPetById(petId.intValue()));
        model.addAttribute("veterinaries", veterinaryService.getAllVeterinaryEntities());
        return "admin/medical_records";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("record", new MedicalRecord());
        model.addAttribute("pets", petService.getAllPets());
        return "admin/medical_record_form";
    }

    @PostMapping("/save")
    public String saveMedicalRecord(@ModelAttribute MedicalRecord record) {
        medicalRecordService.saveMedicalRecord(record);
        return "redirect:/admin/medical-records/pet/" + record.getPet().getPetID();
    }

    @GetMapping("/edit/{id}")
    public String editMedicalRecord(@PathVariable Long id, Model model) {
        MedicalRecord record = medicalRecordService.getMedicalRecordById(id);
        model.addAttribute("record", record);
        model.addAttribute("pets", petService.getAllPets());
        model.addAttribute("veterinaries", veterinaryService.getAllVeterinaryEntities());
        return "admin/edit_medical_record";
    }

    @GetMapping("/delete/{id}")
    public String deleteMedicalRecord(@PathVariable Long id) {
        Long petId = medicalRecordService.getMedicalRecordById(id).getPet().getPetID();
        medicalRecordService.deleteMedicalRecord(id);
        return "redirect:/admin/medical-records/pet/" + petId;
    }

}
