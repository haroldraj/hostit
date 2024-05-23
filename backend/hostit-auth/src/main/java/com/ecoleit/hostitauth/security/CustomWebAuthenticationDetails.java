package com.ecoleit.hostitauth.security;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.web.authentication.WebAuthenticationDetails;

public class CustomWebAuthenticationDetails extends WebAuthenticationDetails {

    private final String verificationCode;

    public CustomWebAuthenticationDetails(HttpServletRequest request, String verificationCode) {
        super(request);
        this.verificationCode = verificationCode;
    }

    public String getVerificationCode() {
        return verificationCode;
    }
}
