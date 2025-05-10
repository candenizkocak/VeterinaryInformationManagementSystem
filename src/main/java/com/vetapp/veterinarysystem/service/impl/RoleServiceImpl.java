package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Role;
import com.vetapp.veterinarysystem.repository.RoleRepository;
import com.vetapp.veterinarysystem.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoleServiceImpl implements RoleService {

    private final RoleRepository roleRepository;

    @Override
    public List<Role> getAllRoles() {
        return roleRepository.findAll();
    }
}
