package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Supplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // Eklendi

import java.util.List;

public interface SupplierRepository extends JpaRepository<Supplier, Long> {

    @Query("SELECT s FROM Supplier s LEFT JOIN FETCH s.locality l LEFT JOIN FETCH l.district d LEFT JOIN FETCH d.city")
    List<Supplier> findAllWithAddressDetails();
}