package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "SurgeryType")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SurgeryType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SurgeryTypeID")
    private Long surgeryTypeId;

    @Column(name = "TypeName", nullable = false)
    private String typeName;

    @Column(name = "Description", columnDefinition = "TEXT")
    private String description;
}
