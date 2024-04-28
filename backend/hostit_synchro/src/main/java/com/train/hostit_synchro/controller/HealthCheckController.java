package com.train.hostit_synchro.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheckController {

    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        // Normally, you would also check the health of your dependencies like databases or other services
        return ResponseEntity.ok("Service is up and running!");
    }
}
