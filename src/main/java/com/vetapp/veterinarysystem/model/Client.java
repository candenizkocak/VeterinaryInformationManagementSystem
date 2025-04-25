package com.vetapp.veterinarysystem.model;



import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Clients")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long clientId;

    @OneToOne
    @JoinColumn(name = "userId", referencedColumnName = "userId")
    private User user;

    private String firstName;
    private String lastName;
    private String address;
}
