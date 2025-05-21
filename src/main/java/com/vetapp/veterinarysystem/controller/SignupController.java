package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class SignupController {

    private final UserService userService;
    private final BCryptPasswordEncoder passwordEncoder;

    public SignupController(UserService userService, BCryptPasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/signup")
    public String showSignupPage() {
        return "signup";
    }

    @PostMapping("/signup")
    public String processSignup(@RequestParam String username,
                                @RequestParam String password,
                                @RequestParam String email,
                                @RequestParam String phone,
                                Model model) {
        try {
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(passwordEncoder.encode(password));
            user.setEmail(email);
            user.setPhone(phone);
            user.setRoleId(1);

            userService.createUser(user);
            return "redirect:/login";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "signup";
        }
    }
}
