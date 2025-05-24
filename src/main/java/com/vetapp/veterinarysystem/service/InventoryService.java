package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Inventory;
import java.util.List;

public interface InventoryService {
    List<Inventory> getInventoryByClinicId(Long clinicId);
    Inventory getInventoryItemById(Long itemId);
    Inventory createInventoryItem(Inventory inventoryItem);
    Inventory updateInventoryItem(Inventory inventoryItem);
    void deleteInventoryItem(Long itemId);
}