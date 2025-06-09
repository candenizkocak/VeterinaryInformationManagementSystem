package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.City;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CityRepository extends JpaRepository<City, Integer> {
    List<City> findAllByOrderByNameAsc();
}