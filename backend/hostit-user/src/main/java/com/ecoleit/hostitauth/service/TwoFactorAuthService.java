package com.ecoleit.hostitauth.service;

import com.ecoleit.hostitauth.entity.User;
import dev.samstevens.totp.code.DefaultCodeGenerator;
import dev.samstevens.totp.code.DefaultCodeVerifier;
import dev.samstevens.totp.secret.DefaultSecretGenerator;
import dev.samstevens.totp.time.SystemTimeProvider;
import com.ecoleit.hostitauth.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class TwoFactorAuthService {

    private final DefaultSecretGenerator secretGenerator = new DefaultSecretGenerator();
    private final DefaultCodeVerifier verifier = new DefaultCodeVerifier(new DefaultCodeGenerator(), new SystemTimeProvider());
    private final UserRepository userRepository;

    public TwoFactorAuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    public String generateSecret() {
        return secretGenerator.generate();
    }

    public String getQRCodeUrl(String secret, String userEmail) {
        return "otpauth://totp/Hostit:" + userEmail + "?secret=" + secret + "&issuer=Hostit";
    }

    public boolean verifyCode(User user, String code) {
        boolean isVerified = verifier.isValidCode(user.getTwoFactorSecret(), code);
        if (isVerified) {
            user.setTwoFactorEnabled(true);
            userRepository.save(user);
        }
        return isVerified;
    }

    public void enableTwoFactor(User user) {
        String secret = generateSecret();
        user.setTwoFactorSecret(secret);
        userRepository.save(user);
    }

    public void disableTwoFactor(User user) {
        user.setTwoFactorSecret(null);
        user.setTwoFactorEnabled(false);
        userRepository.save(user);
    }

}
