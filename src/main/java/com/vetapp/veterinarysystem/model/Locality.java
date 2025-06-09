package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "Localities", schema = "dbo")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Locality {

    @Id
    @Column(name = "Code")
    private Long code;

    @Column(name = "Name", nullable = false)
    private String name;

    @Column(name = "Slug", nullable = false)
    private String slug;

    @Column(name = "Type", nullable = false)
    private String type;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ParentCode", referencedColumnName = "code", nullable = false)
    private District district;
}