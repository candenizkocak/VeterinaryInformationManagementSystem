package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Supplier;
import java.util.List;

public interface SupplierService {
    List<Supplier> getAllSuppliers();
    Supplier getSupplierById(Long id);
    Supplier createSupplier(Supplier supplier);
    void deleteSupplier(Long id);
}