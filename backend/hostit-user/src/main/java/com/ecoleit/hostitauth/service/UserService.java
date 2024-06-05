package com.ecoleit.hostitauth.service;

import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // Méthode pour enregistrer un nouveau compte utilisateur
    public User registerNewUserAccount(User user) throws Exception {
        // Vérifie si l'e-mail existe déjà dans la base de données
        if (emailExist(user.getEmail())) {
            throw new Exception("There is an account with that email address: " + user.getEmail());
        }
        // Crypte le mot de passe avant de l'enregistrer dans la base de données
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // Enregistre le nouvel utilisateur dans la base de données
        return userRepository.save(user);
    }

    // Méthode pour vérifier si un e-mail existe déjà dans la base de données
    public boolean emailExist(String email) {
        return userRepository.findUserByEmail(email).isPresent();
    }

    // Méthode pour rechercher un utilisateur par son nom d'utilisateur
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    // Méthode pour sauvegarder un utilisateur dans la base de données
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    // Des méthodes supplémentaires telles que validateUser, deleteUser, etc., pourraient également être ici.
}
