package com.ecoleit.hostitauth.service;

import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.entity.VerificationToken;
import com.ecoleit.hostitauth.repository.UserRepository;
import com.ecoleit.hostitauth.repository.VerificationTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.Date;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final VerificationTokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserService(UserRepository userRepository, VerificationTokenRepository tokenRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.tokenRepository = tokenRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User registerNewUserAccount(User user) throws Exception {
        if (emailExist(user.getEmail())) {
            throw new Exception("There is an account with that email address: " + user.getEmail());
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public boolean emailExist(String email) {
        return userRepository.findUserByEmail(email).isPresent();
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public User saveUser(User user) {
        return userRepository.save(user);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findUserByEmail(email);
    }

    public void createVerificationToken(User user, String token) {
        VerificationToken verificationToken = new VerificationToken();
        verificationToken.setToken(token);
        verificationToken.setUser(user);
        verificationToken.setExpiryDate(calculateExpiryDate());
        tokenRepository.save(verificationToken);
    }


    public VerificationToken getVerificationToken(String token) {
        return tokenRepository.findByToken(token);
    }

    public void verifyUser(String token) {
        VerificationToken verificationToken = getVerificationToken(token);
        if (verificationToken == null || isTokenExpired(verificationToken)) {
            throw new RuntimeException("Token is invalid or expired!");
        }
        User user = verificationToken.getUser();
        user.setEnabled(true);
        userRepository.save(user);
        tokenRepository.delete(verificationToken);
    }

    private Date calculateExpiryDate() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_YEAR, 1); // Token valid for 1 day
        return calendar.getTime();
    }

    private boolean isTokenExpired(VerificationToken token) {
        final Calendar calendar = Calendar.getInstance();
        return token.getExpiryDate().before(calendar.getTime());
    }
}
