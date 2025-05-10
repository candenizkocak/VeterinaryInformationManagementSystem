package com.vetapp.veterinarysystem.repository;



import com.vetapp.veterinarysystem.model.Client;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClientRepository extends JpaRepository<Client, Long> {
    Client findByUserUsername(String username);
}
