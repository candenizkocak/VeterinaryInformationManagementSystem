package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
    boolean existsByUsername(String username);
    User findByUsernameAndPasswordHash(String username, String passwordHash);
}
