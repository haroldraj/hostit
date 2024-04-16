package com.train.hostitstorage.config;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MinioConfig {

    @Value("${minio.access.name}")
    private String accessKey;

    @Value("${minio.access.secret}")
    private String accessSecret;

    @Value("${minio.url}")
    private String minioUrl;

    @Value("${minio.bucket.name}")
    private String defaultBucketName;

    @Bean
    public MinioClient minioClient() {
        try {
            MinioClient minioClient = MinioClient.builder()
                    .endpoint(minioUrl)
                    .credentials(accessKey, accessSecret)
                    .build();

            // Check if the default bucket exists, and create it if it does not
            boolean found = minioClient.bucketExists(defaultBucketName);
            if (!found) {
                minioClient.makeBucket(defaultBucketName);
            }
            return minioClient;
        } catch (Exception e) {
            throw new RuntimeException("Error initializing MinIO client: ", e);
        }
    }
}
