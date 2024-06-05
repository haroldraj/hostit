package com.train.hostit_synchro.model;

import jakarta.persistence.*;

//import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "sync_history")
public class SyncHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // Identifiant unique de l'historique de synchronisation

    @Column(name = "sync_job_id", nullable = false)
    private Long syncJobId; // Identifiant de la tâche de synchronisation associée

    @Column(nullable = false)
    private String status; // Statut de la synchronisation

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date eventTime; // Horodatage de l'événement de synchronisation

    // Constructeur par défaut
    public SyncHistory() {
    }

    // Constructeur paramétré
    public SyncHistory(Long syncJobId, String status) {
        this.syncJobId = syncJobId;
        this.status = status;
        this.eventTime = new Date(); // Définit l'heure de l'événement comme l'heure actuelle
    }

    // Getters et setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getSyncJobId() {
        return syncJobId;
    }

    public void setSyncJobId(Long syncJobId) {
        this.syncJobId = syncJobId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getEventTime() {
        return eventTime;
    }

    public void setEventTime(Date eventTime) {
        this.eventTime = eventTime;
    }

    // Méthode toString pour les logs et le débogage
    @Override
    public String toString() {
        return "SyncHistory{" +
                "id=" + id +
                ", syncJobId=" + syncJobId +
                ", status='" + status + '\'' +
                ", eventTime=" + eventTime +
                '}';
    }
}
