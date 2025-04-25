package com.vetapp.veterinarysystem.service;



import com.vetapp.veterinarysystem.dto.ClientDto;

import java.util.List;

public interface ClientService {
    ClientDto createClient(ClientDto clientDto);
    ClientDto getClientById(Long id);
    List<ClientDto> getAllClients();
    void deleteClient(Long id);
}
