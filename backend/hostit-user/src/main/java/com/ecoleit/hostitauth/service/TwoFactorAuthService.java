package com.ecoleit.hostitauth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class TwoFactorAuthService {

    private final Map<String, String> codes = new ConcurrentHashMap<>();
    private final JavaMailSender mailSender;

    @Autowired
    public TwoFactorAuthService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public String generateCode(String username) {
        String code = String.valueOf(new Random().nextInt(900000) + 100000); // 6-digit code
        codes.put(username, code);
        return code;
    }

    public void sendCode(String email, String code) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Your 2FA Code");
        message.setText("Your 2FA code is: " + code);
        mailSender.send(message);
    }

    public boolean verifyCode(String username, String code) {
        return code.equals(codes.get(username));
    }
}
