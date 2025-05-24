package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Supplier;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SupplierRepository extends JpaRepository<Supplier, Long> {
}