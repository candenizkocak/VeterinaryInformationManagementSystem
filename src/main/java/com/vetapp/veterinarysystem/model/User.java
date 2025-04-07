package com.vetapp.veterinarysystem.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userID;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false, length = 255)
    private String passwordHash;

    private String email;
    private String phone;

    @Column(name = "RoleID")
    private int roleId;
}
