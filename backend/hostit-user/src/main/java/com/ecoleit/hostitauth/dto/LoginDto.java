package com.ecoleit.hostitauth.dto;


import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
public class LoginDto {

    @NotBlank(message = "Username cannot be blank")
    private String username;

    @NotBlank(message = "Password cannot be blank")
    private String password;

    // Getters and setters for the fields
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // toString, hashCode, equals, can be overridden as needed
}