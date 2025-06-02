// src/main/java/com/vetapp/veterinarysystem/service/SurgeryTypeService.java
package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.SurgeryType;

import java.util.List;

public interface SurgeryTypeService {
    List<SurgeryType> getAllSurgeryTypes();
    SurgeryType getSurgeryTypeById(Long id);
    SurgeryType createSurgeryType(SurgeryType surgeryType); // NEW
    void deleteSurgeryType(Long id); // NEW
}