package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "district") // DDL'deki tablo adı 'district', şema belirtilmemişse varsayılan kullanılır
@Data
@NoArgsConstructor
@AllArgsConstructor
public class District {

    @Id
    @Column(name = "code")
    private int code;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "slug", nullable = false)
    private String slug;

    @Column(name = "type", nullable = false)
    private String type;

    @Column(name = "latitude", nullable = false)
    private String latitude;

    @Column(name = "longitude", nullable = false)
    private String longitude;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parentcode", referencedColumnName = "Code", nullable = false)
    private City city;
}