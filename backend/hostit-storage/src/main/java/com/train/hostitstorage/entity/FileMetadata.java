package com.train.hostitstorage.entity;

import jakarta.persistence.*;

import java.sql.Timestamp;
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

    @Column(name = "content_type")
    @Basic
    private String contentType;

    @Column(name = "file_download_uri")
    @Basic
    private String fileDownloadUri;

    @Column(name = "size")
    @Basic
    private long file_size;

    @Column(name = "upload_time")
    @Basic
    private Timestamp uploadDate;

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

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getFileDownloadUri() {
        return fileDownloadUri;
    }

    public void setFileDownloadUri(String fileDownloadUri) {
        this.fileDownloadUri = fileDownloadUri;
    }

    public long getFile_size() {
        return file_size;
    }

    public void setFile_size(long file_size) {
        this.file_size = file_size;
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
        return file_size == that.file_size && Objects.equals(id, that.id) && Objects.equals(fileName, that.fileName) && Objects.equals(contentType, that.contentType) && Objects.equals(fileDownloadUri, that.fileDownloadUri) && Objects.equals(uploadDate, that.uploadDate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, fileName, contentType, fileDownloadUri, file_size, uploadDate);
    }
}
