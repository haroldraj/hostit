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
    public String accessKey ;

    @Value("${minio.secretKey}")
    public String secretKey;

    @Value("${minio.host.ip.address}")
    public String minioHostAddress;

    @Value("${minio.bucketName}")
    public String defaultBucketName;

    @Bean
    public MinioClient minioClient() {
        try {
            String minioUrl = "http://" + minioHostAddress+":9000";
            MinioClient minioClient = MinioClient.builder()
                    .endpoint(minioUrl)
                    .credentials(accessKey, secretKey)
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