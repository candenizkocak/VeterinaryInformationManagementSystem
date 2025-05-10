package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.dto.VeterinaryDto;
import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.UserRepository;
import com.vetapp.veterinarysystem.repository.VeterinaryRepository;
import com.vetapp.veterinarysystem.service.VeterinaryService;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class VeterinaryServiceImpl implements VeterinaryService {

    private final VeterinaryRepository veterinaryRepository;
    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public VeterinaryServiceImpl(VeterinaryRepository veterinaryRepository, UserRepository userRepository, ModelMapper modelMapper) {
        this.veterinaryRepository = veterinaryRepository;
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public VeterinaryDto createVeterinary(VeterinaryDto veterinaryDto) {
        User user = userRepository.findByUsername(veterinaryDto.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found!"));

        Veterinary veterinary = modelMapper.map(veterinaryDto, Veterinary.class);
        veterinary.setUser(user);

        Veterinary savedVeterinary = veterinaryRepository.save(veterinary);

        return modelMapper.map(savedVeterinary, VeterinaryDto.class);
    }

    @Override
    public VeterinaryDto getVeterinaryById(Long id) {
        Veterinary veterinary = veterinaryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Veterinary not found!"));
        return modelMapper.map(veterinary, VeterinaryDto.class);
    }

    //@Override
    //public List<VeterinaryDto> getAllVeterinaries() {
    //    return veterinaryRepository.findAll().stream()
    //            .map(veterinary -> modelMapper.map(veterinary, VeterinaryDto.class))
    //            .collect(Collectors.toList());
    //}

    @Override
    public List<VeterinaryDto> getAllVeterinaries() {
        return veterinaryRepository.findAll().stream()
                .map(vet -> {
                    VeterinaryDto dto = modelMapper.map(vet, VeterinaryDto.class);
                    dto.setUsername(vet.getUser().getUsername()); // emir bu satır username çekmek için gerekli bir sıkıntı olursa düzeltiriz senin kodunu yorum olarak bıraktım
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Veterinary> getAllVeterinaryEntities() {
        return veterinaryRepository.findAll();
    }


    @Override
    public VeterinaryDto updateVeterinary(Long id, VeterinaryDto veterinaryDto) {
        return null;
    }

    @Override
    public void deleteVeterinary(Long id) {
        veterinaryRepository.deleteById(id);
    }

    @Override
    public ResponseEntity<?> login(String username, String password) {
        return null;
    }

    @Override
    public Veterinary createVeterinaryFromEntity(Veterinary veterinary) {
        return veterinaryRepository.save(veterinary);
    }

    @Override
    public Veterinary getVeterinaryEntityById(Long id) {
        return veterinaryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Veterinary not found"));
    }

    @Override
    public Veterinary updateVeterinaryEntity(Veterinary veterinary) {
        return veterinaryRepository.save(veterinary);
    }
}
