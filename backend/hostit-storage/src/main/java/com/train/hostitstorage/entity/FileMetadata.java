package com.train.hostitstorage.entity;

import jakarta.persistence.*;
import org.checkerframework.common.aliasing.qual.Unique;

import java.sql.Timestamp;
import java.util.Objects;

@Entity
@Table(name = "file_metadata", schema = "hostit_storage", catalog = "")
public class FileMetadata {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    @Basic
    @Unique
    private String name;

    @Column(name = "content_type")
    @Basic
    private String contentType;

    @Column(name = "download_uri")
    @Basic
    private String downloadUri;

    @Column(name = "size")
    @Basic
    private long size;

    @Column(name = "upload_date")
    @Basic
    private Timestamp uploadDate;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getDownloadUri() {
        return downloadUri;
    }

    public void setDownloadUri(String downloadUri) {
        this.downloadUri = downloadUri;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof FileMetadata that)) return false;
        return size == that.size && Objects.equals(id, that.id) && Objects.equals(name, that.name) && Objects.equals(contentType, that.contentType) && Objects.equals(downloadUri, that.downloadUri) && Objects.equals(uploadDate, that.uploadDate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, contentType, downloadUri, size, uploadDate);
    }
}
