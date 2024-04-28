package com.train.hostit_synchro.config;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import com.train.hostit_synchro.service.SyncService;

@Configuration
@EnableScheduling
public class SyncConfig {

    @Value("${minio.url}")
    private String minioUrl;

    @Value("${minio.accessKey}")
    private String accessKey;

    @Value("${minio.secretKey}")
    private String secretKey;

    @Value("${minio.bucket.name}")
    private String defaultBucketName;

    private final SyncService syncService;

    public SyncConfig(SyncService syncService) {
        this.syncService = syncService;
    }

    @Bean
    public MinioClient minioClient() {
        return MinioClient.builder()
                .endpoint(minioUrl)
                .credentials(accessKey, secretKey)
                .build();
    }

    // Scheduled task for synchronization
    @Scheduled(cron = "${sync.cron.expression}")
    public void performScheduledSync() {
        // Call synchronization logic from SyncService
        syncService.syncWithMinio(defaultBucketName);
    }

    // Additional configurations or scheduled tasks can be added here
}
