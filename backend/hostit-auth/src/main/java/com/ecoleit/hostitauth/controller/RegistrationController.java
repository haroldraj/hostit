package com.ecoleit.hostitauth.controller;

import com.ecoleit.hostitauth.dto.UserRegistrationDto;
import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.EmailService;
import com.ecoleit.hostitauth.service.UserService;
import com.ecoleit.hostitauth.util.TwoFactorAuthenticationUtil;
import dev.samstevens.totp.exceptions.QrGenerationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
public class RegistrationController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final TwoFactorAuthenticationUtil twoFactorAuthUtil;

    @Autowired
    public RegistrationController(UserService userService, PasswordEncoder passwordEncoder, EmailService emailService, TwoFactorAuthenticationUtil twoFactorAuthUtil) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
        this.twoFactorAuthUtil = twoFactorAuthUtil;
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody UserRegistrationDto registrationDto) {
        if (registrationDto.getUsername() == null || registrationDto.getPassword() == null) {
            return ResponseEntity.badRequest().body("Username and password are required");
        }

        if (userService.findByUsername(registrationDto.getUsername()).isPresent()) {
            return ResponseEntity.badRequest().body("Username is already taken");
        }

        if (userService.emailExist(registrationDto.getEmail())) {
            return ResponseEntity.badRequest().body("Email is already taken");
        }

        User newUser = new User();
        newUser.setUsername(registrationDto.getUsername());
        newUser.setPassword(passwordEncoder.encode(registrationDto.getPassword()));
        newUser.setEmail(registrationDto.getEmail());
        newUser.setEnabled(false);

        // Generate 2FA secret key
        String secret = twoFactorAuthUtil.generateSecretKey();
        newUser.setSecret(secret);
        newUser.setIs2FAEnabled(false); // 2FA is initially disabled

        userService.saveUser(newUser);

        String token = UUID.randomUUID().toString();
        userService.createVerificationToken(newUser, token);

        String verificationUrl = "http://localhost:8000/auth/verify?token=" + token;
        String qrCodeUri = twoFactorAuthUtil.getTotpUrl(secret, newUser.getUsername(), "HostIT");
        String qrCodeUrl = "http://localhost:8000/auth/verify?token=" + qrCodeUri;

        String qrCodeDataUri;
        String qrCodeDataUrl;
        try {
            qrCodeDataUri = twoFactorAuthUtil.generateQrCodeDataUri(secret, newUser.getUsername(), "HostIT");
            qrCodeDataUrl = "data:image/png;base64," + qrCodeDataUri;
        } catch (QrGenerationException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error generating QR code");
        }

        String emailBody = "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;\">"
                + "<h1 style=\"color: #333; text-align: center;\">Welcome to HostIT!</h1>"
                + "<p style=\"color: #555;\">Hello " + registrationDto.getUsername() + ",</p>"
                + "<p style=\"color: #555;\">I am named Loique Darios, the CEO of HOSTIT. On behalf of the entire HostIT team, we want to thank you for registering with us. We are excited to have you on board and look forward to providing you with the best service possible.</p>"
                + "<p style=\"color: #555;\">Please click the button below to verify your email address and complete your registration:</p>"
                + "<div style=\"text-align: center; margin: 20px 0;\">"
                + "<a href=\"" + verificationUrl + "\" style=\"display: inline-block; padding: 10px 20px; color: #fff; background-color: #007bff; text-decoration: none; border-radius: 5px;\">Verify Email</a>"
                + "</div>"
                + "<p style=\"color: #555;\">If you did not register for this account, please ignore this email.</p>"
                + "<p style=\"color: #555;\">Thank you,</p>"
                + "<p style=\"color: #555;\">The HostIT Team</p>"
                + "<div style=\"text-align: center; margin-top: 40px;\">"
                + "<p style=\"color: #007bff; font-weight: bold; font-size: 18px;\">HOSTIT</p>"
                + "</div>"
                + "<p style=\"color: #555;\">Quickly accept the 2FA by clicking the button below:</p>"
                + "<div style=\"text-align: center; margin: 20px 0;\">"
                + "<a href=\"" + qrCodeUrl + "\" style=\"display: inline-block; padding: 10px 20px; color: #fff; background-color: #28a745; text-decoration: none; border-radius: 5px;\">Set up 2FA</a>"
                + "</div>"
                + "<p style=\"color: #555;\">Or scan the QR code below:</p>"
                + "<div style=\"text-align: center;\">"
                + "<img src=\"" + qrCodeDataUrl + "\" alt=\"QR Code\" />"
                + "</div>"
                + "</div>";

        try {
            emailService.sendHtmlMessage(newUser.getEmail(), "Email Verification", emailBody);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error sending verification email");
        }

        return ResponseEntity.ok("User registered successfully. Please check your email to verify your account.");
    }

    @GetMapping("/verify")
    public ResponseEntity<?> verifyEmail(@RequestParam String token) {
        try {
            userService.verifyUser(token);
            return ResponseEntity.ok("Email verified successfully.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
