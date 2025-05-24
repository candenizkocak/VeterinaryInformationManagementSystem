package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    List<Inventory> findByClinic_ClinicId(Long clinicId);
}