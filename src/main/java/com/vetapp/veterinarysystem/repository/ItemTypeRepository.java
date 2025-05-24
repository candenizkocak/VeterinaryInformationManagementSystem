package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.ItemType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItemTypeRepository extends JpaRepository<ItemType, Long> {
}