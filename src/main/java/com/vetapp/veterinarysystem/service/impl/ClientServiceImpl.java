package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.ClientDto;
import com.vetapp.veterinarysystem.model.Client;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.service.ClientService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ClientServiceImpl implements ClientService {

    private final ClientRepository clientRepository;
    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public ClientServiceImpl(ClientRepository clientRepository, UserRepository userRepository, ModelMapper modelMapper) {
        this.clientRepository = clientRepository;
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public ClientDto createClient(ClientDto clientDto) {

        User user = userRepository.findByUsername(clientDto.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found!"));

        // DTO → Entity
        Client client = modelMapper.map(clientDto, Client.class);
        client.setUser(user);

        Client savedClient = clientRepository.save(client);

        // Entity → DTO
        return modelMapper.map(savedClient, ClientDto.class);
    }

    @Override
    public ClientDto getClientById(Long id) {
        Client client = clientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Client not found!"));

        return modelMapper.map(client, ClientDto.class);
    }

    @Override
    public List<ClientDto> getAllClients() {
        return clientRepository.findAll().stream()
                .map(client -> modelMapper.map(client, ClientDto.class))
                .collect(Collectors.toList());
    }

    @Override
    public void deleteClient(Long id) {
        clientRepository.deleteById(id);
    }
}
