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

    // Endpoint pour l'authentification de l'utilisateur
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody UserDto userDto) {
        // Tente d'authentifier l'utilisateur avec les informations fournies
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(
                        userDto.getUsername(),
                        userDto.getPassword()
                );

        try {
            // Authentifie l'utilisateur auprès du gestionnaire d'authentification de Spring Security
            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            // Met à jour le contexte de sécurité avec l'authentification réussie
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // Récupère les détails de l'utilisateur à partir du service UserService
            Optional<User> userOptional = userService.findByUsername(userDto.getUsername());
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                // Crée une carte pour stocker les détails de l'utilisateur
                Map<String, Object> claims = new HashMap<>();
                claims.put("id", user.getId());
                claims.put("username", user.getUsername());
                claims.put("email", user.getEmail());

                // Génère un jeton JWT avec les détails de l'utilisateur comme revendications
                String jwtToken = Jwts.builder()
                        .setClaims(claims)
                        .setIssuedAt(new Date())
                        .setExpiration(new Date((new Date()).getTime() + 3600000)) // 1 heure de validité du jeton
                        .signWith(SignatureAlgorithm.HS256, "yourSecretKey") // Clé secrète pour signer le jeton (devrait être sécurisée)
                        .compact();

                // Crée une carte pour stocker le jeton JWT
                Map<String, String> tokenMap = new HashMap<>();
                tokenMap.put("token", jwtToken);
                // Retourne le jeton JWT dans la réponse
                return ResponseEntity.ok(tokenMap);
            } else {
                return ResponseEntity.status(404).body("User not found");
            }
        } catch (Exception e) {
            // Gère l'échec d'authentification
            return ResponseEntity.status(401).body("Authentication failed: " + e.getMessage());
        }
    }

    // D'autres endpoints tels que changer le mot de passe, réinitialiser le mot de passe, etc. peuvent être ajoutés ici.
}
