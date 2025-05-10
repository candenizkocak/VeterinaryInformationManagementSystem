







/*******DEEPSEEK*********
// PetService.java
package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Pet;
import java.util.List;
import java.util.Optional;

public interface PetService {
    List<Pet> findAll();
    Optional<Pet> findById(Long id);
    Pet save(Pet pet);
    void deleteById(Long id);
    List<Pet> findByClientId(Long clientId);
}
 */