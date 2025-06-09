package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Locality;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LocalityRepository extends JpaRepository<Locality, Long> {
    List<Locality> findByDistrictCodeOrderByNameAsc(int districtCode);
}