package com.ecoleit.hostitauth.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    // This method defines which URL paths should be secured and which should not.
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                // Disable CSRF (Cross Site Request Forgery) for simplicity, enable it in production.
                .csrf().disable()
                // Specify the URL patterns that should be secured.
                .authorizeRequests()
                // Permit all requests to the auth and home endpoints.
                .antMatchers("/auth/**", "/").permitAll()
                // All other requests should be authenticated.
                .anyRequest().authenticated()
                .and()
                // Define the login page and permit all access to it.
                .formLogin().loginPage("/login").permitAll()
                .and()
                // Define the logout behavior.
                .logout().permitAll();
    }

    // This method is for overriding the default AuthenticationManagerBuilder.
    // You can specify how the user details are loaded (in-memory, database, LDAP, etc).
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        // Here you should add your userDetailsService and password encoder
        auth
                .inMemoryAuthentication()
                .withUser("user")
                .password(passwordEncoder().encode("password"))
                .roles("USER");
    }

    // Declare the password encoder bean.
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
