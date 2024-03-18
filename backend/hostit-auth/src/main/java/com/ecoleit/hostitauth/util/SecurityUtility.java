package com.ecoleit.hostitauth.util;

import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class SecurityUtility {

    // This Bean could also be declared in a @Configuration class

    // You could add more utility methods related to security here
    // For example, methods for JWT token creation and validation,
    // methods for 2FA, etc.
}
