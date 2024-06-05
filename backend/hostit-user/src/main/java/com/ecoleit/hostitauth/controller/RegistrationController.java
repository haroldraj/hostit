package com.ecoleit.hostitauth.controller;

import com.ecoleit.hostitauth.dto.UserRegistrationDto;
import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class RegistrationController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public RegistrationController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    // Endpoint pour l'enregistrement d'un nouvel utilisateur
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody UserRegistrationDto registrationDto) {
        // Valide le DTO (objet de transfert de données) fourni
        if (registrationDto.getUsername() == null || registrationDto.getPassword() == null) {
            return ResponseEntity.badRequest().body("Username and password are required");
        }

        // Vérifie si l'utilisateur existe déjà
        if (userService.findByUsername(registrationDto.getUsername()).isPresent()) {
            return ResponseEntity.badRequest().body("Username is already taken");
        }

        // Vérifie si l'e-mail existe déjà
        if (userService.emailExist(registrationDto.getEmail())) {
            return ResponseEntity.badRequest().body("Email is already taken");
        }

        // Crée un nouvel utilisateur et définit ses propriétés à partir du DTO
        User newUser = new User();
        newUser.setUsername(registrationDto.getUsername());
        newUser.setPassword(passwordEncoder.encode(registrationDto.getPassword())); // Crypte le mot de passe avant de le stocker
        newUser.setEmail(registrationDto.getEmail());
        // Vous voudrez peut-être définir d'autres propriétés ou rôles également

        // Enregistre le nouvel utilisateur dans la base de données
        userService.saveUser(newUser);

        return ResponseEntity.ok("User registered successfully");
    }

    // Ajoutez d'autres endpoints si nécessaire, tels que pour la confirmation de l'e-mail, etc.
}
