package com.train.hostitstorage.model;

import jakarta.persistence.*;

import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "file_metadata", schema = "hostit_storage", catalog = "")
public class FileMetadata {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "file_name")
    @Basic
    private String fileName;

    @Column(name = "file_type")
    @Basic
    private String fileType;

    @Column(name = "file_download_uri")
    @Basic
    private String fileDownloadUri;

    @Column(name = "size")
    @Basic
    private long size;

    @Column(name = "upload_time")
    @Basic
    private Date uploadTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getFileDownloadUri() {
        return fileDownloadUri;
    }

    public void setFileDownloadUri(String fileDownloadUri) {
        this.fileDownloadUri = fileDownloadUri;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public Date getUploadTime() {
        return uploadTime;
    }

    public void setUploadTime(Date uploadTime) {
        this.uploadTime = uploadTime;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof FileMetadata that)) return false;
        return size == that.size && Objects.equals(id, that.id) && Objects.equals(fileName, that.fileName) && Objects.equals(fileType, that.fileType) && Objects.equals(fileDownloadUri, that.fileDownloadUri) && Objects.equals(uploadTime, that.uploadTime);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, fileName, fileType, fileDownloadUri, size, uploadTime);
    }
}
