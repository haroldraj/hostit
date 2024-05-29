package com.ecoleit.hostitauth.security.filter;

import com.ecoleit.hostitauth.service.TwoFactorAuthService;
import com.ecoleit.hostitauth.service.UserService;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CustomAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    private final TwoFactorAuthService twoFactorAuthService;
    private final UserService userService;

    public CustomAuthenticationFilter(AuthenticationManager authenticationManager, UserService userService, TwoFactorAuthService twoFactorAuthService) {
        super.setAuthenticationManager(authenticationManager);
        this.twoFactorAuthService = twoFactorAuthService;
        this.userService = userService;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        String username = obtainUsername(request);
        String password = obtainPassword(request);

        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(username, password);
        setDetails(request, authRequest);
        Authentication auth = this.getAuthenticationManager().authenticate(authRequest);

        if (auth.isAuthenticated()) {
            String code = twoFactorAuthService.generateCode(username);
            String email = userService.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found")).getEmail();
            twoFactorAuthService.sendCode(email, code);
        }

        return auth;
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authResult) throws IOException, ServletException {
        String username = authResult.getName();
        String code = request.getParameter("code");

        if (twoFactorAuthService.verifyCode(username, code)) {
            super.successfulAuthentication(request, response, chain, authResult);
        } else {
            throw new BadCredentialsException("Invalid 2FA code");
        }
    }
}
