package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.Inventory;
import com.vetapp.veterinarysystem.model.ItemType;
import com.vetapp.veterinarysystem.model.Supplier;
import com.vetapp.veterinarysystem.repository.ClinicRepository;
import com.vetapp.veterinarysystem.repository.InventoryRepository;
import com.vetapp.veterinarysystem.repository.ItemTypeRepository;
import com.vetapp.veterinarysystem.repository.SupplierRepository;
import com.vetapp.veterinarysystem.service.InventoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class InventoryServiceImpl implements InventoryService {

    private final InventoryRepository inventoryRepository;
    private final ClinicRepository clinicRepository;
    private final ItemTypeRepository itemTypeRepository;
    private final SupplierRepository supplierRepository;

    @Override
    public List<Inventory> getInventoryByClinicId(Long clinicId) {
        return inventoryRepository.findByClinic_ClinicId(clinicId);
    }

    @Override
    public Inventory getInventoryItemById(Long itemId) {
        return inventoryRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Inventory item not found with ID: " + itemId));
    }

    @Override
    public Inventory createInventoryItem(Inventory inventoryItem) {
        // Ensure associated entities are managed
        Clinic clinic = clinicRepository.findById(inventoryItem.getClinic().getClinicId())
                .orElseThrow(() -> new RuntimeException("Clinic not found"));
        ItemType itemType = itemTypeRepository.findById(inventoryItem.getItemTypeId().getItemTypeId())
                .orElseThrow(() -> new RuntimeException("Item Type not found"));
        Supplier supplier = null;
        if (inventoryItem.getSupplier() != null && inventoryItem.getSupplier().getSupplierId() != null) {
            supplier = supplierRepository.findById(inventoryItem.getSupplier().getSupplierId())
                    .orElseThrow(() -> new RuntimeException("Supplier not found"));
        }

        inventoryItem.setClinic(clinic);
        inventoryItem.setItemTypeId(itemType);
        inventoryItem.setSupplier(supplier);
        inventoryItem.setLastUpdated(LocalDateTime.now()); // Set current timestamp
        return inventoryRepository.save(inventoryItem);
    }

    @Override
    public Inventory updateInventoryItem(Inventory inventoryItem) {
        Inventory existingItem = inventoryRepository.findById(inventoryItem.getItemId())
                .orElseThrow(() -> new RuntimeException("Inventory item not found with ID: " + inventoryItem.getItemId()));

        // Ensure associated entities are managed
        Clinic clinic = clinicRepository.findById(inventoryItem.getClinic().getClinicId())
                .orElseThrow(() -> new RuntimeException("Clinic not found"));
        ItemType itemType = itemTypeRepository.findById(inventoryItem.getItemTypeId().getItemTypeId())
                .orElseThrow(() -> new RuntimeException("Item Type not found"));
        Supplier supplier = null;
        if (inventoryItem.getSupplier() != null && inventoryItem.getSupplier().getSupplierId() != null) {
            supplier = supplierRepository.findById(inventoryItem.getSupplier().getSupplierId())
                    .orElseThrow(() -> new RuntimeException("Supplier not found"));
        }

        existingItem.setClinic(clinic);
        existingItem.setItemTypeId(itemType);
        existingItem.setSupplier(supplier);
        existingItem.setQuantity(inventoryItem.getQuantity());
        existingItem.setLastUpdated(LocalDateTime.now()); // Update last updated time

        return inventoryRepository.save(existingItem);
    }

    @Override
    public void deleteInventoryItem(Long itemId) {
        inventoryRepository.deleteById(itemId);
    }
}