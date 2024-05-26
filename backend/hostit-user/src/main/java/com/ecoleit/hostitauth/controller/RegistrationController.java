package com.ecoleit.hostitauth.controller;

import com.ecoleit.hostitauth.dto.UserRegistrationDto;
import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
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

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody UserRegistrationDto registrationDto) {
        // Validate the provided DTO (data transfer object)
        if (registrationDto.getUsername() == null || registrationDto.getPassword() == null) {
            return ResponseEntity.badRequest().body("Username and password are required");
        }

        // Check if user already exists
        if (userService.findByUsername(registrationDto.getUsername()).isPresent()) {
            return ResponseEntity.badRequest().body("Username is already taken");
        }

        // Check if email already exists
        if (userService.emailExist(registrationDto.getEmail())) {
            return ResponseEntity.badRequest().body("Email is already taken");
        }

        // Create a new user and set its properties from the DTO
        User newUser = new User();
        newUser.setUsername(registrationDto.getUsername());
        newUser.setPassword(passwordEncoder.encode(registrationDto.getPassword()));
        newUser.setEmail(registrationDto.getEmail());
        // You might want to set other properties or roles as well

        // Save the new user
        userService.saveUser(newUser);

        return ResponseEntity.ok("User registered successfully");
    }

    // Add other endpoints if necessary, such as for email confirmation, etc.
}
