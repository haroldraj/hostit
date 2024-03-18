package com.ecoleit.hostitauth.controller;

import com.ecoleit.hostitauth.dto.UserDto;
import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthenticationController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public AuthenticationController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }



    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody UserDto userDto) {
        // Implement login logic. With Spring Security, this is typically handled automatically
        // when you configure your SecurityConfig with formLogin() or similar, but you can
        // add additional logic here if needed, such as logging login attempts.
        return ResponseEntity.ok().build();
    }

    // You might want to add endpoints for changing passwords, resetting passwords, etc.

}
