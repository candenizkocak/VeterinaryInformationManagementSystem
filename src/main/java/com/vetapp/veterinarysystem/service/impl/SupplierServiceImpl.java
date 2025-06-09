package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.SupplierDto;
import com.vetapp.veterinarysystem.model.District;
import com.vetapp.veterinarysystem.model.Locality;
import com.vetapp.veterinarysystem.model.Supplier;
import com.vetapp.veterinarysystem.repository.SupplierRepository;
import com.vetapp.veterinarysystem.service.LocalityService;
import com.vetapp.veterinarysystem.service.SupplierService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SupplierServiceImpl implements SupplierService {

    private final SupplierRepository supplierRepository;
    private final LocalityService localityService;
    private final ModelMapper modelMapper;

    @Override
    @Transactional
    public List<SupplierDto> getAllSuppliers() { // <-- DÖNÜŞ TİPİ DEĞİŞTİ
        // Entity listesini çek, sonra DTO listesine dönüştür
        return supplierRepository.findAllWithAddressDetails().stream()
                .map(this::convertToSupplierDto) // Her entity'yi DTO'ya dönüştür
                .collect(Collectors.toList());
    }

    @Override
    public Supplier getSupplierById(Long id) {
        // Bu metod hala model entity döndürüyor. Dışarıdan hala Supplier entity'si bekleyen yerler için.
        return supplierRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Supplier not found with ID: " + id));
    }

    @Override
    @Transactional
    public SupplierDto createSupplier(SupplierDto supplierDto) {
        // ... (Bu metod aynı kalır) ...
        Supplier supplier = new Supplier();
        supplier.setCompanyName(supplierDto.getCompanyName());
        supplier.setContactName(supplierDto.getContactName());
        supplier.setPhone(supplierDto.getPhone());
        supplier.setEmail(supplierDto.getEmail());

        if (supplierDto.getLocalityCode() != null) {
            Locality locality = localityService.getLocalityByCode(supplierDto.getLocalityCode())
                    .orElseThrow(() -> new IllegalArgumentException("Locality not found for code: " + supplierDto.getLocalityCode()));
            supplier.setLocality(locality);
        } else {
            supplier.setLocality(null);
        }
        supplier.setStreetAddress(supplierDto.getStreetAddress());
        supplier.setPostalCode(supplierDto.getPostalCode());

        Supplier savedSupplier = supplierRepository.save(supplier);
        return convertToSupplierDto(savedSupplier);
    }

    @Override
    @Transactional
    public SupplierDto updateSupplier(Long id, SupplierDto supplierDto) {
        // ... (Bu metod aynı kalır) ...
        Supplier existingSupplier = supplierRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Supplier not found with ID: " + id));

        existingSupplier.setCompanyName(supplierDto.getCompanyName());
        existingSupplier.setContactName(supplierDto.getContactName());
        existingSupplier.setPhone(supplierDto.getPhone());
        existingSupplier.setEmail(supplierDto.getEmail());

        if (supplierDto.getLocalityCode() != null) {
            Locality locality = localityService.getLocalityByCode(supplierDto.getLocalityCode())
                    .orElseThrow(() -> new IllegalArgumentException("Locality not found for code: " + supplierDto.getLocalityCode()));
            existingSupplier.setLocality(locality);
        } else {
            existingSupplier.setLocality(null);
        }
        existingSupplier.setStreetAddress(supplierDto.getStreetAddress());
        existingSupplier.setPostalCode(supplierDto.getPostalCode());

        Supplier updatedSupplier = supplierRepository.save(existingSupplier);
        return convertToSupplierDto(updatedSupplier);
    }

    @Override
    public void deleteSupplier(Long id) {
        supplierRepository.deleteById(id);
    }

    // Helper method to convert Supplier entity to SupplierDto
    private SupplierDto convertToSupplierDto(Supplier supplier) {
        SupplierDto dto = new SupplierDto();
        dto.setSupplierId(supplier.getSupplierId());
        dto.setCompanyName(supplier.getCompanyName());
        dto.setContactName(supplier.getContactName());
        dto.setPhone(supplier.getPhone());
        dto.setEmail(supplier.getEmail());

        // Yeni adres alanlarını DTO'ya aktar
        if (supplier.getLocality() != null) {
            dto.setLocalityCode(supplier.getLocality().getCode());
            Locality locality = supplier.getLocality();
            if (locality.getDistrict() != null) {
                dto.setDistrictCode(locality.getDistrict().getCode());
                District district = locality.getDistrict();
                if (district.getCity() != null) {
                    dto.setCityCode(district.getCity().getCode());
                }
            }
        }
        dto.setStreetAddress(supplier.getStreetAddress());
        dto.setPostalCode(supplier.getPostalCode());

        // Formatlanmış adresi burada oluşturup DTO'ya set et
        dto.setFormattedAddress(formatSupplierAddress(supplier));

        return dto;
    }

    // Helper method to format supplier address for display
    private String formatSupplierAddress(Supplier supplier) {
        StringBuilder addressBuilder = new StringBuilder();

        // Sokak adresi
        if (supplier.getStreetAddress() != null && !supplier.getStreetAddress().isEmpty()) {
            addressBuilder.append(supplier.getStreetAddress());
        }

        // Mahalle, İlçe, İl
        if (supplier.getLocality() != null) {
            if (addressBuilder.length() > 0) addressBuilder.append(", ");
            addressBuilder.append(supplier.getLocality().getName());

            if (supplier.getLocality().getDistrict() != null) {
                addressBuilder.append(" / ").append(supplier.getLocality().getDistrict().getName());

                if (supplier.getLocality().getDistrict().getCity() != null) {
                    addressBuilder.append(" / ").append(supplier.getLocality().getDistrict().getCity().getName());
                }
            }
        }

        // Posta Kodu
        if (supplier.getPostalCode() != null && !supplier.getPostalCode().isEmpty()) {
            if (addressBuilder.length() > 0) addressBuilder.append(" - ");
            addressBuilder.append(supplier.getPostalCode());
        }

        return addressBuilder.toString();
    }
}