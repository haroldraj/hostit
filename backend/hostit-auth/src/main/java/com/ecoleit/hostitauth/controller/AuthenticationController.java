package com.ecoleit.hostitauth.controller;

import com.ecoleit.hostitauth.dto.UserDto;
import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.UserService;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class AuthenticationController {

    private final AuthenticationManager authenticationManager;
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public AuthenticationController(AuthenticationManager authenticationManager, UserService userService, PasswordEncoder passwordEncoder) {
        this.authenticationManager = authenticationManager;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody UserDto userDto) {
        // Attempt to authenticate the user with the provided credentials
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(
                        userDto.getUsername(),
                        userDto.getPassword()
                );

        try {
            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            SecurityContextHolder.getContext().setAuthentication(authentication);
            // You can now return a custom response or JWT token if needed
            // ...

            // Retrieve user details
           Optional<User> userOptional = userService.findByUsername(userDto.getUsername());
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                // Create a map to hold user details
                Map<String, Object> claims = new HashMap<>();
                claims.put("id", user.getId());
                claims.put("username", user.getUsername());
                claims.put("email", user.getEmail());

                // Generate JWT token with user details as claims
              String jwtToken = Jwts.builder()
                        .setClaims(claims)
                        .setIssuedAt(new Date())
                        .setExpiration(new Date((new Date()).getTime() + 3600000)) // 1 hour expiration time
                        .signWith(SignatureAlgorithm.HS256, "yourSecretKey")
                        .compact();
                // Create a map to hold the JWT token
                Map<String, String> tokenMap = new HashMap<>();
                tokenMap.put("token", jwtToken);
                // Return JWT token
                return ResponseEntity.ok(tokenMap);
           } else {
                return ResponseEntity.status(404).body("User not found");
            }
        } catch (Exception e) {
            // Handle authentication failure
            return ResponseEntity.status(401).body("Authentication failed: " + e.getMessage());
        }
    }

    // Additional endpoints such as change password, reset password, etc.
}
