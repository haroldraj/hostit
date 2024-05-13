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
    public String accessKey = "B7CvxeruN5dwA9oGJEGr";


    @Value("${minio.access.secret}")
    public String accessSecret = "dOzJqkAh80L6veSwog1jKUqm79tWcN152qBoB5Ez";

    @Value("${minio.url}")
    public String minioUrl = "http://192.168.129.5:9090/api/v1/service-account-credentials";

    @Value("${minio.bucket.name}")
    public String defaultBucketName = "minio-hostit-bucket";

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
