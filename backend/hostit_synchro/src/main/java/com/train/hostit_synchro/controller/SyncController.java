package com.train.hostit_synchro.controller;

import com.train.hostit_synchro.dto.SyncRequestDto;
import com.train.hostit_synchro.dto.FileSyncStatusDto;
import com.train.hostit_synchro.service.SyncService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/sync")
public class SyncController {

    private final SyncService syncService;

    @Autowired
    public SyncController(SyncService syncService) {
        this.syncService = syncService;
    }

    @PostMapping("/start")
    public ResponseEntity<?> startSynchronization(@RequestBody SyncRequestDto syncRequestDto) {
        try {
            syncService.startSynchronization(syncRequestDto);
            return ResponseEntity.ok().body("Synchronization has started successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error starting synchronization: " + e.getMessage());
        }
    }

    @GetMapping("/status/{syncJobId}")
    public ResponseEntity<?> checkSynchronizationStatus(@PathVariable String syncJobId) {
        try {
            // Assuming getSyncStatus method is modified to return FileSyncStatusDto
            String status = syncService.getSyncStatus(syncJobId);
            return ResponseEntity.ok(status);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error retrieving synchronization status: " + e.getMessage());
        }
    }


    @PostMapping("/stop")
    public ResponseEntity<?> stopSynchronization(@RequestBody String syncJobId) {
        try {
            syncService.stopSynchronization(syncJobId);
            return ResponseEntity.ok().body("Synchronization has been requested to stop.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Error stopping synchronization: " + e.getMessage());
        }
    }

    public FileSyncStatusDto getSyncStatus(String syncJobId) {
        // Logic to get the current status of the sync job
        // This is just a placeholder. You would implement actual logic here.
        return new FileSyncStatusDto(syncJobId, "In Progress", "The sync is currently being processed");
    }


    // Additional controller methods for other synchronization operations can be added here.
}
