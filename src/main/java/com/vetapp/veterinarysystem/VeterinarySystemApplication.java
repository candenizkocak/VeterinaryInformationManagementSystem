package com.vetapp.veterinarysystem;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.vetapp.veterinarysystem")
public class VeterinarySystemApplication {
	public static void main(String[] args) {
		SpringApplication.run(VeterinarySystemApplication.class, args);
	}
}
