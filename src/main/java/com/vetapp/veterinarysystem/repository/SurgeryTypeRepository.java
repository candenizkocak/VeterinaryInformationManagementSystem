package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.SurgeryType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SurgeryTypeRepository extends JpaRepository<SurgeryType, Long> {
}
