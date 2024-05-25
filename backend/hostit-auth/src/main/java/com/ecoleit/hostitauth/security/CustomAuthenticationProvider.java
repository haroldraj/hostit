package com.ecoleit.hostitauth.security;

import com.ecoleit.hostitauth.entity.User;
import com.ecoleit.hostitauth.service.UserService;
import com.ecoleit.hostitauth.util.TwoFactorAuthenticationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Collections;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private TwoFactorAuthenticationUtil twoFactorAuthenticationUtil;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();
        String totpCode = ((TwoFactorAuthenticationToken) authentication).getTotpCode();

        User user = userService.findByUsername(username)
                .orElseThrow(() -> new BadCredentialsException("Invalid username or password"));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new BadCredentialsException("Invalid username or password");
        }

        if (user.is2FAEnabled() && !twoFactorAuthenticationUtil.verifyCode(user.getSecret(), totpCode)) {
            throw new BadCredentialsException("Invalid TOTP code");
        }

        return new UsernamePasswordAuthenticationToken(username, password, Collections.emptyList());
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(TwoFactorAuthenticationToken.class);
    }
}
