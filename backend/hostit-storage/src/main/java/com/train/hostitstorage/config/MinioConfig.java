package com.train.hostitstorage.config;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.minio.BucketExistsArgs;
import io.minio.MakeBucketArgs;

@Configuration
public class MinioConfig {

    @Value("${minio.accessKey}")
    public String accessKey = "Q3AM3UQ867SPQQA43P2F";


    @Value("${minio.access.secret}")
    public String accessSecret = "K1VIUWqUuLsD8pLcpP3yLUF2vFe6yzSQp9UXEbXM";

    @Value("${minio.url}")
    public String minioUrl = "http://192.168.17.1:54711/api/v1/service-account-credentials";

    @Value("${minio.bucket.name}")
    public String defaultBucketName = "hostit";

    @Bean
    public MinioClient minioClient() {
        try {
            MinioClient minioClient = MinioClient.builder()
                    .endpoint(minioUrl)
                    .credentials(accessKey, accessSecret)
                    .build();

            // Check if the default bucket exists, and create it if it does not
            boolean found = minioClient.bucketExists(BucketExistsArgs.builder().bucket(defaultBucketName).build());
            if (!found) {
                minioClient.makeBucket(MakeBucketArgs.builder().bucket(defaultBucketName).build());
            }
            return minioClient;
        } catch (Exception e) {
            throw new RuntimeException("Error initializing MinIO client: ", e);
        }
    }
}
