package com.train.hostit_synchro.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.client.RestTemplate;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;

@Configuration
@PropertySource("classpath:application.properties")
public class SynchroConfig {

    @Value("${minio.url}")
    private String minioUrl;

    @Value("${minio.accessKey}")
    private String minioAccessKey;

    @Value("${minio.secretKey}")
    private String minioSecretKey;

    @Value("${firebase.credentials.path}")
    private String firebaseCredentialsPath;

    @Bean
    public MinioClient minioClient() {
        try {
            return MinioClient.builder()
                    .endpoint(minioUrl)
                    .credentials(minioAccessKey, minioSecretKey)
                    .build();
        } catch (Exception e) {
            throw new RuntimeException("Error initializing MinIO client: ", e);
        }
    }

    @Bean
    public FirebaseApp firebaseApp() throws IOException, GeneralSecurityException {
        InputStream serviceAccount = new FileInputStream(firebaseCredentialsPath);
        FirebaseOptions options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();
        return FirebaseApp.initializeApp(options);
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    // Add more beans for synchronization service configuration as needed
}
