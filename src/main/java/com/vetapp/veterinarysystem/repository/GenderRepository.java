package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Gender;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GenderRepository extends JpaRepository<Gender, Integer> {
}
