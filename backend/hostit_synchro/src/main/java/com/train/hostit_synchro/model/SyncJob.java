package com.train.hostit_synchro.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "sync_jobs")
public class SyncJob {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String sourcePath;

    @Column(nullable = false)
    private String targetPath;

    @Column(nullable = false)
    private boolean recursive;

    @Column(nullable = false)
    private String status;

    @Column
    @Temporal(TemporalType.TIMESTAMP)
    private Date startTime;

    @Column
    @Temporal(TemporalType.TIMESTAMP)
    private Date endTime;

    // Default constructor
    public SyncJob() {
    }

    // Parametrized constructor
    public SyncJob(String sourcePath, String targetPath, boolean recursive, String status) {
        this.sourcePath = sourcePath;
        this.targetPath = targetPath;
        this.recursive = recursive;
        this.status = status;
        this.startTime = new Date(); // Set start time as current time
    }

    // Getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSourcePath() {
        return sourcePath;
    }

    public void setSourcePath(String sourcePath) {
        this.sourcePath = sourcePath;
    }

    public String getTargetPath() {
        return targetPath;
    }

    public void setTargetPath(String targetPath) {
        this.targetPath = targetPath;
    }

    public boolean isRecursive() {
        return recursive;
    }

    public void setRecursive(boolean recursive) {
        this.recursive = recursive;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    // toString method for logging and debugging purposes
    @Override
    public String toString() {
        return "SyncJob{" +
                "id=" + id +
                ", sourcePath='" + sourcePath + '\'' +
                ", targetPath='" + targetPath + '\'' +
                ", recursive=" + recursive +
                ", status='" + status + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                '}';
    }
}
