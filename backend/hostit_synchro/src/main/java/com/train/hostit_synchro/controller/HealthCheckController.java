package com.train.hostit_synchro.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheckController {

    // Endpoint pour effectuer une vérification de santé
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        // Normalement, vous vérifieriez également la santé de vos dépendances telles que les bases de données ou d'autres services
        return ResponseEntity.ok("Service is up and running!"); // Retourne une réponse indiquant que le service fonctionne correctement
    }
}
