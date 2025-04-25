package com.vetapp.veterinarysystem.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        String role = (String) session.getAttribute("role");

        if (role == null) {
            return "redirect:/login";
        }

        session.setAttribute("role", role);

        return "dashboard";
    }
}

