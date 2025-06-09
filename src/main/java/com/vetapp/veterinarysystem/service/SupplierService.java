package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.dto.SupplierDto;
import com.vetapp.veterinarysystem.model.Supplier; // Model nesnesini de tutuyoruz çünkü bazı yerlerde lazım olabilir
import java.util.List;

public interface SupplierService {
    List<SupplierDto> getAllSuppliers();
    Supplier getSupplierById(Long id);
    SupplierDto createSupplier(SupplierDto supplierDto);
    SupplierDto updateSupplier(Long id, SupplierDto supplierDto);
    void deleteSupplier(Long id);
}