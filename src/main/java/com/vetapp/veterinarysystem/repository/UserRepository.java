package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByUsername(String username);
    Optional<User> findByUsername(String username);
    List<User> findByRoleRoleName(String roleName);

}
