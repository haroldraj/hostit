package com.ecoleit.hostitanalytics.dto;

import java.util.Date;

public class FileDTO {

    private Long id;
    private String contentType;
    private String downloadUri;
    private String name;
    private Long size;
    private Date uploadDate;
    private String folderName;

    // Constructors
    public FileDTO() {
    }

    public FileDTO(Long id, String contentType, String downloadUri, String name, Long size, Date uploadDate, String folderName) {
        this.id = id;
        this.contentType = contentType;
        this.downloadUri = downloadUri;
        this.name = name;
        this.size = size;
        this.uploadDate = uploadDate;
        this.folderName = folderName;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getSize() {
        return size;
    }

    public void setSize(Long size) {
        this.size = size;
    }

    public Date getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Date uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getFolderName() {
        return folderName;
    }

    public void setFolderName(String folderName) {
        this.folderName = folderName;
    }
}
