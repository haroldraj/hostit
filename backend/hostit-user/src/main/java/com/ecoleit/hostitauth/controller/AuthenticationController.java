package com.ecoleit.hostitauth.controller;

import com.ecoleit.hostitauth.dto.UserDto;
import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.QRCodeGeneratorService;
import com.ecoleit.hostitauth.service.TwoFactorAuthService;
import com.ecoleit.hostitauth.service.UserService;
import com.google.zxing.WriterException;
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

import java.io.IOException;
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
    private final TwoFactorAuthService twoFactorAuthService;
    private final QRCodeGeneratorService qrCodeGeneratorService;

    @Autowired
    public AuthenticationController(AuthenticationManager authenticationManager, UserService userService, PasswordEncoder passwordEncoder, TwoFactorAuthService twoFactorAuthService, QRCodeGeneratorService qrCodeGeneratorService) {
        this.authenticationManager = authenticationManager;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.twoFactorAuthService = twoFactorAuthService;
        this.qrCodeGeneratorService = qrCodeGeneratorService;
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
            SecurityContextHolder.getContext().setAuthentication(authentication);

            Optional<User> userOptional = userService.findByUsername(userDto.getUsername());
            if (userOptional.isPresent()) {
                User user = userOptional.get();

                if (user.isTwoFactorEnabled()) {
                    Map<String, String> response = new HashMap<>();
                    response.put("2fa_required", "true");
                    return ResponseEntity.ok(response);
                }

                String jwtToken = generateJwtToken(user);
                Map<String, String> tokenMap = new HashMap<>();
                tokenMap.put("token", jwtToken);
                return ResponseEntity.ok(tokenMap);
            } else {
                return ResponseEntity.status(404).body("User not found");
            }
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Authentication failed: " + e.getMessage());
        }
    }

    @PostMapping("/verify-2fa")
    public ResponseEntity<?> verify2FA(@RequestBody Map<String, String> request) {
        String username = request.get("username");
        String code = request.get("code");

        Optional<User> userOptional = userService.findByUsername(username);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (twoFactorAuthService.verifyCode(user, code)) {
                String jwtToken = generateJwtToken(user);
                Map<String, String> tokenMap = new HashMap<>();
                tokenMap.put("token", jwtToken);
                return ResponseEntity.ok(tokenMap);
            } else {
                return ResponseEntity.status(401).body("Invalid 2FA code");
            }
        } else {
            return ResponseEntity.status(404).body("User not found");
        }
    }

    @PostMapping("/enable-2fa")
    public ResponseEntity<?> enable2FA(@RequestBody UserDto userDto) throws WriterException, IOException {
        Optional<User> userOptional = userService.findByUsername(userDto.getUsername());
        System.out.println("User found");
        if (userOptional.isPresent()) {
            System.out.println("User found");
            User user = userOptional.get();
            twoFactorAuthService.enableTwoFactor(user);
            String qrCodeText = twoFactorAuthService.getQRCodeUrl(user.getTwoFactorSecret(), user.getEmail());
            String qrCodeImage = qrCodeGeneratorService.generateQRCodeImage(qrCodeText);
            return ResponseEntity.ok(qrCodeImage);
        } else {
            return ResponseEntity.status(404).body("User not found");
        }
    }

    private String generateJwtToken(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("id", user.getId());
        claims.put("username", user.getUsername());
        claims.put("email", user.getEmail());
        claims.put("twoFactorEnabled", user.isTwoFactorEnabled());
        claims.put("emailVerified", user.isEmailVerified());

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(new Date())
                .setExpiration(new Date((new Date()).getTime() + 3600000)) // 1 hour validity
                .signWith(SignatureAlgorithm.HS256, "yourSecretKey") // Use a secure key
                .compact();
    }
}

