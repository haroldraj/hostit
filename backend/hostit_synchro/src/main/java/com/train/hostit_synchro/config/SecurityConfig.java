package com.train.hostit_synchro.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // Configuration de la sécurité de l'application
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/health").permitAll() // Autoriser toutes les demandes à l'endpoint de vérification de santé
                        .anyRequest().authenticated() // Toutes les autres demandes doivent être authentifiées
                )
                .httpBasic(httpBasic -> {}); // Utiliser l'authentification de base HTTP avec une configuration personnalisée

        // Désactiver CSRF s'il s'agit d'une API REST ou si la gestion du jeton CSRF est implémentée différemment
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }

    // Configuration de l'encodeur de mot de passe pour utiliser BCrypt
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
