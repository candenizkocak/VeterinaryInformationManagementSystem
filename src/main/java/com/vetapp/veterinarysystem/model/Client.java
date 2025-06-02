package com.vetapp.veterinarysystem.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "Clients")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ClientID")
    private Long clientId;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "UserID", referencedColumnName = "UserID")
    private User user;

    @Column(name = "FirstName", length = 50)
    private String firstName;

    @Column(name = "LastName", length = 50)
    private String lastName;

    @Column(name = "Address", length = 255)
    private String address;

    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    @JsonManagedReference  // appointment.jsp sayfasında loopu önlemek için
    private List<Pet> pets;

}




