package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.User;

import java.util.List;

public interface UserService {
    List<User> getAllUsers();
    User getUserById(int id);
    User createUser(User user);
    User updateUser(int id, User user);
    void deleteUser(int id);
    User findByUsernameAndPassword(String username, String password);
}
