package com.train.hostitstorage.entity;

import jakarta.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "files", schema = "hostit_storage")
public class File {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Column(name = "objectName", nullable = false)
    private String objectName;

    @Column(name = "objectSize")
    private long objectSize;

    @Column(name = "contentType")
    private String contentType;

    @Column(name = "createdAt")
    private Timestamp createdAt;

    @Column(name = "bucketName", nullable = false)
    private String bucketName;

    // Standard getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getObjectName() {
        return objectName;
    }

    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }

    public long getObjectSize() {
        return objectSize;
    }

    public void setObjectSize(long objectSize) {
        this.objectSize = objectSize;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getBucketName() {
        return bucketName;
    }

    public void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        File file = (File) o;
        return id == file.id &&
                objectSize == file.objectSize &&
                Objects.equals(objectName, file.objectName) &&
                Objects.equals(contentType, file.contentType) &&
                Objects.equals(createdAt, file.createdAt) &&
                Objects.equals(bucketName, file.bucketName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, objectName, objectSize, contentType, createdAt, bucketName);
    }
}
