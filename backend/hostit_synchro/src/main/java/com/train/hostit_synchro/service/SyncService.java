package com.train.hostit_synchro.service;

import com.train.hostit_synchro.model.SyncEvent;
import org.springframework.stereotype.Service;

@Service
public class SyncService {

    public void handleLocalFileChange(String filePath) {
        // Logic to handle local file changes
        // This method will be invoked when a change is detected in the local file system
        System.out.println("Handling local file change: " + filePath);
        // Emit a sync event
        emitSyncEvent("LOCAL_FILE_CHANGE");
    }

    public void handleRemoteFileChange(String filePath) {
        // Logic to handle remote file changes
        // This method will be invoked when a change is detected in the remote file system
        System.out.println("Handling remote file change: " + filePath);
        // Emit a sync event
        emitSyncEvent("REMOTE_FILE_CHANGE");
    }

    private void emitSyncEvent(String eventType) {
        // Logic to emit a sync event
        // This method will create and publish a SyncEvent to notify about the synchronization event
        SyncEvent syncEvent = new SyncEvent(eventType);
        // Here you can publish the event using WebSocket, HTTP request, or any other appropriate method
        System.out.println("Sync event emitted: " + syncEvent.getEventType());
    }
}
