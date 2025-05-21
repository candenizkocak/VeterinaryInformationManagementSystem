package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.dto.ClientDetailDto;
import com.vetapp.veterinarysystem.dto.ClientDto;
import com.vetapp.veterinarysystem.dto.PetInfoDto;

import java.util.List;

public interface ClientService {
    ClientDto createClient(ClientDto clientDto);
    ClientDto getClientById(Long id);
    List<ClientDto> getAllClients();
    ClientDto updateClient(Long id, ClientDto clientDto);
    List<PetInfoDto> getPetsOfClient(String username);
    ClientDetailDto getClientDetailByUsername(String username);
        void deleteClient(Long id);
}
