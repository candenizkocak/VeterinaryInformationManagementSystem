package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Client;
import com.vetapp.veterinarysystem.model.Veterinary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VeterinaryRepository extends JpaRepository<Veterinary, Long> {
    Optional<Veterinary> findByUserUsername(String username);
}
