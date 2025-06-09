package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.ClinicDto;
import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.Locality;
import com.vetapp.veterinarysystem.model.District; // Import eklendi
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClinicRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.service.ClinicService;
import com.vetapp.veterinarysystem.service.LocalityService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper; // ModelMapper import edildi
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ClinicServiceImpl implements ClinicService {

    private final ClinicRepository clinicRepository;
    private final UserRepository userRepository;
    private final LocalityService localityService;
    private final ModelMapper modelMapper;

    @Override
    @Transactional
    public List<Clinic> getAllClinics() {
        return clinicRepository.findAllWithAddressDetails();
    }

    @Override
    @Transactional
    public List<ClinicDto> getAllClinicsDto() {
        return clinicRepository.findAllWithAddressDetails().stream()
                .map(this::convertToClinicDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public Clinic createClinic(ClinicDto clinicDto) {
        User user = userRepository.findById(clinicDto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Clinic clinic = new Clinic();
        clinic.setUser(user);
        clinic.setClinicName(clinicDto.getClinicName());

        if (clinicDto.getLocalityCode() != null) {
            Locality locality = localityService.getLocalityByCode(clinicDto.getLocalityCode())
                    .orElseThrow(() -> new IllegalArgumentException("Locality not found for code: " + clinicDto.getLocalityCode()));
            clinic.setLocality(locality);
        } else {
            clinic.setLocality(null);
        }
        clinic.setStreetAddress(clinicDto.getStreetAddress());
        clinic.setPostalCode(clinicDto.getPostalCode());

        clinic.setOpeningHour(clinicDto.getOpeningHour());
        clinic.setClosingHour(clinicDto.getClosingHour());
        return clinicRepository.save(clinic);
    }

    @Override
    public Clinic getClinicById(Long id) {
        return clinicRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Clinic not found with ID: " + id));
    }

    @Override
    @Transactional
    public Clinic updateClinic(ClinicDto clinicDto) {
        Clinic clinic = clinicRepository.findById(clinicDto.getClinicId())
                .orElseThrow(() -> new RuntimeException("Clinic not found with ID: " + clinicDto.getClinicId()));

        User user = userRepository.findById(clinicDto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        clinic.setClinicName(clinicDto.getClinicName());

        if (clinicDto.getLocalityCode() != null) {
            Locality locality = localityService.getLocalityByCode(clinicDto.getLocalityCode())
                    .orElseThrow(() -> new IllegalArgumentException("Locality not found for code: " + clinicDto.getLocalityCode()));
            clinic.setLocality(locality);
        } else {
            clinic.setLocality(null);
        }
        clinic.setStreetAddress(clinicDto.getStreetAddress());
        clinic.setPostalCode(clinicDto.getPostalCode());

        clinic.setOpeningHour(clinicDto.getOpeningHour());
        clinic.setClosingHour(clinicDto.getClosingHour());
        clinic.setUser(user);
        return clinicRepository.save(clinic);
    }

    @Override
    public void deleteClinic(Long id) {
        clinicRepository.deleteById(id);
    }

    private ClinicDto convertToClinicDto(Clinic clinic) {
        ClinicDto dto = new ClinicDto();
        dto.setClinicId(clinic.getClinicId());
        dto.setUserId(clinic.getUser() != null ? clinic.getUser().getUserID() : null);
        dto.setClinicName(clinic.getClinicName());
        dto.setOpeningHour(clinic.getOpeningHour());
        dto.setClosingHour(clinic.getClosingHour());

        if (clinic.getLocality() != null) {
            dto.setLocalityCode(clinic.getLocality().getCode());
            if (clinic.getLocality().getDistrict() != null) {
                dto.setDistrictCode(clinic.getLocality().getDistrict().getCode());
                if (clinic.getLocality().getDistrict().getCity() != null) {
                    dto.setCityCode(clinic.getLocality().getDistrict().getCity().getCode());
                }
            }
        }
        dto.setStreetAddress(clinic.getStreetAddress());
        dto.setPostalCode(clinic.getPostalCode());

        dto.setFormattedAddress(formatClinicAddress(clinic));

        return dto;
    }

    private String formatClinicAddress(Clinic clinic) {
        StringBuilder addressBuilder = new StringBuilder();

        if (clinic.getStreetAddress() != null && !clinic.getStreetAddress().isEmpty()) {
            addressBuilder.append(clinic.getStreetAddress());
        }

        if (clinic.getLocality() != null) {
            if (addressBuilder.length() > 0) addressBuilder.append(", ");
            addressBuilder.append(clinic.getLocality().getName());

            if (clinic.getLocality().getDistrict() != null) {
                addressBuilder.append(" / ").append(clinic.getLocality().getDistrict().getName());

                if (clinic.getLocality().getDistrict().getCity() != null) {
                    addressBuilder.append(" / ").append(clinic.getLocality().getDistrict().getCity().getName());
                }
            }
        }

        if (clinic.getPostalCode() != null && !clinic.getPostalCode().isEmpty()) {
            if (addressBuilder.length() > 0) addressBuilder.append(" - ");
            addressBuilder.append(clinic.getPostalCode());
        }

        return addressBuilder.toString();
    }
    @Override
    @Transactional
    public List<ClinicDto> getClinicsByDistrictCode(Integer districtCode) {
        return clinicRepository.findAllWithAddressDetails().stream()
                .filter(c -> c.getLocality() != null
                        && c.getLocality().getDistrict() != null
                        && c.getLocality().getDistrict().getCode() == districtCode)
                .map(this::convertToClinicDto)
                .collect(Collectors.toList());
    }

}
