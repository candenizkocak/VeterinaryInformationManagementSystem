package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.dto.ClinicDto;
import com.vetapp.veterinarysystem.model.Clinic;

import java.util.List;

public interface ClinicService {
    List<Clinic> getAllClinics();
    Clinic createClinic(ClinicDto clinicDto);
    void deleteClinic(int id);
}



/************DEEPSEEK********
 // ClinicService.java
 package com.vetapp.veterinarysystem.service;

 import com.vetapp.veterinarysystem.model.Clinic;
 import java.util.List;
 import java.util.Optional;

 public interface ClinicService {
 List<Clinic> findAll();
 Optional<Clinic> findById(Long id);
 Clinic save(Clinic clinic);
 void deleteById(Long id);
 }
*/


