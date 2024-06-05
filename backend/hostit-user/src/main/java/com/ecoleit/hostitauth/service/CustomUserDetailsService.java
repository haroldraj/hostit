package com.ecoleit.hostitauth.service;

import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.repository.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList; // Importe la classe ArrayList

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Autowired
    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // Recherche l'utilisateur dans la base de données par son nom d'utilisateur
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Username not found: " + username));

        // Crée un objet UserDetails basé sur les informations de l'utilisateur récupérées
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(), // Nom d'utilisateur
                user.getPassword(), // Mot de passe (déjà crypté)
                true, true, true, true, // Active, AccountNonExpired, CredentialsNonExpired, AccountNonLocked
                new ArrayList<>() // Vous devriez définir les autorisations en fonction des rôles de l'utilisateur.
        );
    }
}
