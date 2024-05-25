package com.ecoleit.hostitanalytics.entitie;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "file_metadata")
public class FileMetadata {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "file_type")
    private String fileType;

    @Column(name = "file_size")
    private Long fileSize;

    @Column(name = "upload_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date uploadDate;

    @Column(name = "directory_id")
    private Integer directoryId;

    // Constructors
    public FileMetadata() {
    }

    public FileMetadata(Integer userId, String fileType, Long fileSize, Date uploadDate, Integer directoryId) {
        this.userId = userId;
        this.fileType = fileType;
        this.fileSize = fileSize;
        this.uploadDate = uploadDate;
        this.directoryId = directoryId;
    }

    // Getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public Date getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Date uploadDate) {
        this.uploadDate = uploadDate;
    }

    public Integer getDirectoryId() {
        return directoryId;
    }

    public void setDirectoryId(Integer directoryId) {
        this.directoryId = directoryId;
    }

    // toString method for debugging
    @Override
    public String toString() {
        return "FileMetadata{" +
                "id=" + id +
                ", userId=" + userId +
                ", fileType='" + fileType + '\'' +
                ", fileSize=" + fileSize +
                ", uploadDate=" + uploadDate +
                ", directoryId=" + directoryId +
                '}';
    }
}
