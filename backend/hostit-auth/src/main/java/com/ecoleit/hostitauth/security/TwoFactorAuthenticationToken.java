package com.ecoleit.hostitauth.security;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

public class TwoFactorAuthenticationToken extends UsernamePasswordAuthenticationToken {

    private final String totpCode;

    public TwoFactorAuthenticationToken(Object principal, Object credentials, String totpCode) {
        super(principal, credentials);
        this.totpCode = totpCode;
    }

    public String getTotpCode() {
        return totpCode;
    }
}
