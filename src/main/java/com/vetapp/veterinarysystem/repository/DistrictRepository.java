package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.District;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DistrictRepository extends JpaRepository<District, Integer> {
    List<District> findByCityCodeOrderByNameAsc(int cityCode);
}