package com.ecoleit.hostitauth.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

public class UserDto {

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 15, message = "Username must be between 3 and 15 characters")
    private String username;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters long")
    private String password;

    @NotBlank(message = "Confirm Password is required")
    @Size(min = 6, message = "Confirm Password must be at least 6 characters long")
    private String confirmPassword;

    @NotBlank(message = "Email is required")
    private String email;

    public @NotBlank(message = "Email is required") String getEmail() {
        return email;
    }

    public void setEmail(@NotBlank(message = "Email is required") String email) {
        this.email = email;
    }

    // Getters and setters

    // Your getters and setters here

    // Optionally, you can add a method to check if password and confirm password match
    public boolean isPasswordConfirmed() {
        return this.password != null && this.password.equals(this.confirmPassword);
    }

    //get user name
    public String getUsername() {
        return username;
    }

    //set user name
    public void setUsername(String username) {
        this.username = username;
    }

    //get user password
    public String getPassword() {
        return password;
    }

    //set user password
    public void setPassword(String password) {
        this.password = password;
    }
}
