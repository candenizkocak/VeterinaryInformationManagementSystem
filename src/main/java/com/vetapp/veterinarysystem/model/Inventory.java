package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "Inventory")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Inventory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ItemID")
    private Long itemId;

    @ManyToOne
    @JoinColumn(name = "ClinicID", nullable = false)
    private Clinic clinic;

    @ManyToOne
    @JoinColumn(name = "ItemTypeID", nullable = false)
    private ItemType itemTypeId;

    @ManyToOne
    @JoinColumn(name = "SupplierID")
    private Supplier supplier; // SupplierID is NULLABLE

    @Column(name = "Quantity")
    private Integer quantity;

    @Column(name = "LastUpdated")
    private LocalDateTime lastUpdated;
}