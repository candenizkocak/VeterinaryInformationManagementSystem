package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.ItemType;
import java.util.List;

public interface ItemTypeService {
    List<ItemType> getAllItemTypes();
    ItemType getItemTypeById(Long id);
    ItemType createItemType(ItemType itemType);
    void deleteItemType(Long id);
}