package com.train.hostit_synchro.model;

import java.time.LocalDateTime;

public class SyncEvent {

    private String eventType; // Type d'événement de synchronisation
    private LocalDateTime timestamp; // Horodatage de l'événement

    // Constructeur par défaut
    public SyncEvent() {
        // Constructeur par défaut vide
    }

    // Constructeur avec le type d'événement en paramètre
    public SyncEvent(String eventType) {
        this.eventType = eventType;
        this.timestamp = LocalDateTime.now(); // Initialise le timestamp à l'heure actuelle
    }

    // Getter pour le type d'événement
    public String getEventType() {
        return eventType;
    }

    // Setter pour le type d'événement
    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    // Getter pour le timestamp
    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    // Setter pour le timestamp
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}
