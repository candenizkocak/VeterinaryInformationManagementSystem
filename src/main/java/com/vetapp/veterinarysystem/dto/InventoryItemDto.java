package com.vetapp.veterinarysystem.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class InventoryItemDto {
    private Long itemId;
    private Long clinicId;
    private String clinicName;
    private Long itemTypeId;
    private String itemTypeName;
    private Long supplierId;
    private String supplierName;
    private Integer quantity;
    private LocalDateTime lastUpdated;
}