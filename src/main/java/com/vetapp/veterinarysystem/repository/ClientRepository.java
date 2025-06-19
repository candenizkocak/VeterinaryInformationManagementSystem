package com.vetapp.veterinarysystem.repository;



import com.vetapp.veterinarysystem.model.Client;
import com.vetapp.veterinarysystem.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ClientRepository extends JpaRepository<Client, Long> {
    Optional<Client> findByUserUsername(String username);
    boolean existsByUser(User user);
    Optional<Client> findByUser(User user);
    void deleteByUser(User user);

}
