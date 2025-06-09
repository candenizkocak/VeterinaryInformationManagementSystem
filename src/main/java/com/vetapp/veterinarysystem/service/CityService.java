package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.City;
import java.util.List;
import java.util.Optional;

public interface CityService {
    List<City> getAllCities();
    Optional<City> getCityByCode(int code);
}