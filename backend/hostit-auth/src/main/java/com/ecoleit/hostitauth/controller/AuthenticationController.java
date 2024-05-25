package com.ecoleit.hostitauth.controller;

import com.ecoleit.hostitauth.dto.UserDto;
import com.ecoleit.hostitauth.dto.TwoFactorAuthDto;
import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.UserService;
import com.ecoleit.hostitauth.util.TwoFactorAuthenticationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthenticationController {

    private final AuthenticationManager authenticationManager;
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final TwoFactorAuthenticationUtil twoFactorAuthenticationUtil;

    @Autowired
    public AuthenticationController(AuthenticationManager authenticationManager, UserService userService, PasswordEncoder passwordEncoder, TwoFactorAuthenticationUtil twoFactorAuthenticationUtil) {
        this.authenticationManager = authenticationManager;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.twoFactorAuthenticationUtil = twoFactorAuthenticationUtil;
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody UserDto userDto) {
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(
                        userDto.getUsername(),
                        userDto.getPassword()
                );

        try {
            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            User user = (User) authentication.getPrincipal();

            if (user.is2FAEnabled()) {
                // Generate and send 2FA code
                String secret = user.getSecret();
                String code = twoFactorAuthenticationUtil.generateSecretKey(); // Adjust as per your 2FA setup
                // Logic to send 2FA code to the user (e.g., via email or SMS)
                return ResponseEntity.status(202).body("2FA code sent. Please verify.");
            }

            SecurityContextHolder.getContext().setAuthentication(authentication);
            return ResponseEntity.ok("User logged in successfully!");
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Authentication failed: " + e.getMessage());
        }
    }

    @PostMapping("/verify-2fa")
    public ResponseEntity<?> verifyTwoFactorAuthentication(@RequestBody TwoFactorAuthDto twoFactorAuthDto) {
        try {
            User user = userService.findByUsername(twoFactorAuthDto.getUsername())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            boolean isValid = twoFactorAuthenticationUtil.verifyCode(user.getSecret(), twoFactorAuthDto.getCode());
            if (!isValid) {
                return ResponseEntity.status(401).body("Invalid 2FA code");
            }

            UsernamePasswordAuthenticationToken authenticationToken =
                    new UsernamePasswordAuthenticationToken(
                            user.getUsername(),
                            user.getPassword()
                    );

            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            SecurityContextHolder.getContext().setAuthentication(authentication);

            return ResponseEntity.ok("2FA verification successful. User logged in.");
        } catch (Exception e) {
            return ResponseEntity.status(401).body("2FA verification failed: " + e.getMessage());
        }
    }
}
