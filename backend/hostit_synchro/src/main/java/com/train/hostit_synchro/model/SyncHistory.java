package com.train.hostit_synchro.model;

import jakarta.persistence.*;

//import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "sync_history")
public class SyncHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sync_job_id", nullable = false)
    private Long syncJobId;

    @Column(nullable = false)
    private String status;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date eventTime;

    // Default constructor
    public SyncHistory() {
    }

    // Parametrized constructor
    public SyncHistory(Long syncJobId, String status) {
        this.syncJobId = syncJobId;
        this.status = status;
        this.eventTime = new Date(); // Set event time as current time
    }

    // Getters and setters
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

    // toString method for logging and debugging purposes
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
