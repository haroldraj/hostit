package com.train.hostit_synchro.config;

import io.minio.MinioClient;
import io.minio.errors.MinioException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import com.train.hostit_synchro.service.SyncService;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@Configuration
@EnableScheduling
public class SyncConfig {

    // Injecter les valeurs des propriétés Minio depuis le fichier de configuration
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

    // Configuration du client Minio pour communiquer avec le serveur Minio
    @Bean
    public MinioClient minioClient() {
        return MinioClient.builder()
                .endpoint(minioUrl)
                .credentials(accessKey, secretKey)
                .build();
    }

    // Tâche planifiée pour la synchronisation
    @Scheduled(cron = "${sync.cron.expression}")
    public void performScheduledSync() throws MinioException, IOException, NoSuchAlgorithmException, InvalidKeyException {
        // Appeler la logique de synchronisation depuis SyncService
        syncService.syncWithMinio(defaultBucketName);
    }

    // Des configurations supplémentaires ou des tâches planifiées peuvent être ajoutées ici
}
