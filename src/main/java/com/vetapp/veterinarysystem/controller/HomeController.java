package com.vetapp.veterinarysystem.controller;

import com.vetapp.veterinarysystem.model.User;
import com.vetapp.veterinarysystem.repository.ClientRepository;
import com.vetapp.veterinarysystem.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final UserRepository userRepository;
    private final ClientRepository clientRepository;

    @GetMapping("/")
    public String home(Principal principal) {
        if (principal == null) {
            // Kullanıcı giriş yapmamış, direkt ana sayfa göster
            return "home";
        }

        String username = principal.getName();
        User user = userRepository.findByUsername(username).orElse(null);

        if (user == null) {
            // Kullanıcı bulunamadıysa ana sayfa göster
            return "home";
        }

        String roleName = user.getRole() != null ? user.getRole().getRoleName().toUpperCase() : "";

        System.out.println("🌈 Kullanıcının rolü: " + roleName);

        // Role bazlı kontrol: Client ise Client kaydı var mı kontrol et
        if (roleName.contains("CLIENT")) {
            boolean hasClient = clientRepository.findByUser(user).isPresent();
            System.out.println("🔍 Client kaydı var mı? " + hasClient);

            if (!hasClient) {
                // Client kaydı yoksa register sayfasına yönlendir
                return "redirect:/api/clients/register";
            }
        }

        // Diğer durumlarda normal ana sayfa (home.jsp) göster
        return "home";
    }
}
