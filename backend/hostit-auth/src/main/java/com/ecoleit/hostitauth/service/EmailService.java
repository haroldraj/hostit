package com.ecoleit.hostitauth.service;

import jakarta.mail.MessagingException;

public interface EmailService {
    void sendSimpleMessage(String to, String subject, String text);
    void sendMessageWithAttachment(String to, String subject, String text, String pathToAttachment) throws MessagingException;
    void sendHtmlMessage(String email, String emailVerification, String emailBody) throws MessagingException;
}
