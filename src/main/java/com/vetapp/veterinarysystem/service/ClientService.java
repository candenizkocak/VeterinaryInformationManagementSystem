package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.dto.*;
import com.vetapp.veterinarysystem.model.Client;

import java.util.List;

public interface ClientService {
    ClientDto createClient(ClientDto clientDto);
    ClientDto getClientById(Long id);
    List<ClientDto> getAllClients();
    ClientDto updateClient(Long id, ClientDto clientDto);
    List<PetInfoDto> getPetsOfClient(String username);
    ClientDetailDto getClientDetailByUsername(String username);
        void deleteClient(Long id);


    Client getClientByUsername(String username);

    ClientAccountSettingsDto getAccountSettings(String username);
    void updateAccountSettings(String username, ClientAccountSettingsDto dto);

    boolean changePassword(String username, PasswordChangeDto dto);


}
