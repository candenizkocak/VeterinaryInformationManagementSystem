package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.ItemType;
import com.vetapp.veterinarysystem.repository.ItemTypeRepository;
import com.vetapp.veterinarysystem.service.ItemTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemTypeServiceImpl implements ItemTypeService {

    private final ItemTypeRepository itemTypeRepository;

    @Override
    public List<ItemType> getAllItemTypes() {
        return itemTypeRepository.findAll();
    }

    @Override
    public ItemType getItemTypeById(Long id) {
        return itemTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item Type not found with ID: " + id));
    }

    @Override
    public ItemType createItemType(ItemType itemType) {
        return itemTypeRepository.save(itemType);
    }

    @Override
    public void deleteItemType(Long id) {
        itemTypeRepository.deleteById(id);
    }
}