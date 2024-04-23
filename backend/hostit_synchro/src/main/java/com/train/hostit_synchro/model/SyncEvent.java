package com.train.hostit_synchro.model;

import java.time.LocalDateTime;

public class SyncEvent {

    private String eventType;
    private LocalDateTime timestamp;

    public SyncEvent() {
        // Default constructor
    }

    public SyncEvent(String eventType) {
        this.eventType = eventType;
        this.timestamp = LocalDateTime.now();
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}
