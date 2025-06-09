package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.dto.CityDto;
import com.vetapp.veterinarysystem.dto.DistrictDto;
import com.vetapp.veterinarysystem.dto.LocalityDto;
import com.vetapp.veterinarysystem.model.City;
import com.vetapp.veterinarysystem.model.District;
import com.vetapp.veterinarysystem.model.Locality;
import com.vetapp.veterinarysystem.service.CityService;
import com.vetapp.veterinarysystem.service.DistrictService;
import com.vetapp.veterinarysystem.service.LocalityService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/addresses")
@RequiredArgsConstructor
public class AddressController {

    private final CityService cityService;
    private final DistrictService districtService;
    private final LocalityService localityService;
    private final ModelMapper modelMapper;

    @GetMapping("/cities")
    public ResponseEntity<List<CityDto>> getAllCities() {
        List<City> cities = cityService.getAllCities();
        List<CityDto> cityDtos = cities.stream()
                .map(city -> modelMapper.map(city, CityDto.class))
                .collect(Collectors.toList());
        return ResponseEntity.ok(cityDtos);
    }

    @GetMapping("/districts/{cityCode}")
    public ResponseEntity<List<DistrictDto>> getDistrictsByCityCode(@PathVariable int cityCode) {
        List<District> districts = districtService.getDistrictsByCityCode(cityCode);
        List<DistrictDto> districtDtos = districts.stream()
                .map(district -> {
                    DistrictDto dto = modelMapper.map(district, DistrictDto.class);
                    dto.setParentCode(district.getCity().getCode());
                    return dto;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(districtDtos);
    }

    @GetMapping("/localities/{districtCode}")
    public ResponseEntity<List<LocalityDto>> getLocalitiesByDistrictCode(@PathVariable int districtCode) {
        List<Locality> localities = localityService.getLocalitiesByDistrictCode(districtCode);
        List<LocalityDto> localityDtos = localities.stream()
                .map(locality -> {
                    LocalityDto dto = modelMapper.map(locality, LocalityDto.class);
                    dto.setParentCode(locality.getDistrict().getCode());
                    return dto;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(localityDtos);
    }
}