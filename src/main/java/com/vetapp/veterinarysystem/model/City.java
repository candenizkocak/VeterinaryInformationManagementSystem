package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Table(name = "Cities", schema = "dbo")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class City {

    @Id
    @Column(name = "Code")
    private int code;

    @Column(name = "Name", nullable = false)
    private String name;

    @Column(name = "Slug", nullable = false)
    private String slug;

    @Column(name = "Type", nullable = false)
    private String type;

    @Column(name = "Latitude", nullable = false)
    private String latitude;

    @Column(name = "Longitude", nullable = false)
    private String longitude;

    // ParentCode null olabilir, bu yüzden Optional veya Wrapper type INT
    // @Column(name = "ParentCode")
    // private Integer parentCode; // iller için null
}