package com.ecoleit.hostitauth.util;

import dev.samstevens.totp.code.DefaultCodeGenerator;
import dev.samstevens.totp.code.DefaultCodeVerifier;
import dev.samstevens.totp.code.CodeGenerator;
import dev.samstevens.totp.code.CodeVerifier;
import dev.samstevens.totp.exceptions.QrGenerationException;
import dev.samstevens.totp.qr.QrData;
import dev.samstevens.totp.qr.QrGenerator;
import dev.samstevens.totp.qr.ZxingPngQrGenerator;
import dev.samstevens.totp.secret.DefaultSecretGenerator;
import dev.samstevens.totp.secret.SecretGenerator;
import dev.samstevens.totp.time.SystemTimeProvider;
import dev.samstevens.totp.time.TimeProvider;
import dev.samstevens.totp.code.HashingAlgorithm;
import org.springframework.stereotype.Component;

import static dev.samstevens.totp.util.Utils.getDataUriForImage;

@Component // Add this annotation
public class TwoFactorAuthenticationUtil {

    private final SecretGenerator secretGenerator;
    private final CodeGenerator codeGenerator;
    private final CodeVerifier verifier;
    private final TimeProvider timeProvider;
    private final QrGenerator qrGenerator;

    public TwoFactorAuthenticationUtil() {
        this.secretGenerator = new DefaultSecretGenerator();
        this.codeGenerator = new DefaultCodeGenerator();
        this.timeProvider = new SystemTimeProvider();
        this.verifier = new DefaultCodeVerifier(codeGenerator, timeProvider);
        this.qrGenerator = new ZxingPngQrGenerator();
    }

    public String generateSecretKey() {
        return secretGenerator.generate();
    }

    public String getTotpUrl(String secretKey, String account, String issuer) {
        QrData data = new QrData.Builder()
                .label(account)
                .secret(secretKey)
                .issuer(issuer)
                .algorithm(HashingAlgorithm.SHA1) // Use the HashingAlgorithm enum
                .digits(6)
                .period(30)
                .build();

        return String.format("otpauth://totp/%s:%s?secret=%s&issuer=%s",
                issuer, account, secretKey, issuer);
    }

    public byte[] generateQrCode(String secretKey, String account, String issuer) throws QrGenerationException {
        QrData data = new QrData.Builder()
                .label(account)
                .secret(secretKey)
                .issuer(issuer)
                .algorithm(HashingAlgorithm.SHA1) // Use the HashingAlgorithm enum
                .digits(6)
                .period(30)
                .build();

        return qrGenerator.generate(data);
    }

    public String generateQrCodeDataUri(String secretKey, String account, String issuer) throws QrGenerationException {
        byte[] qrCodeImage = generateQrCode(secretKey, account, issuer);
        return getDataUriForImage(qrCodeImage, qrGenerator.getImageMimeType());
    }

    public boolean verifyCode(String secret, String code) {
        return verifier.isValidCode(secret, code);
    }
}
