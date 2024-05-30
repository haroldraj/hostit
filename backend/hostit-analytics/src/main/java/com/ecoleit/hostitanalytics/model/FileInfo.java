package com.ecoleit.hostitanalytics.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "files")
public class FileInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "content_type")
    private String contentType;

    @Column(name = "download_uri")
    private String downloadUri;

    @Column(name = "name")
    private String name;

    @Column(name = "size")
    private Long size;

    @Column(name = "upload_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date uploadDate;

    @Column(name = "folder_name")
    private String folderName;

    // Constructors
    public FileInfo() {
    }

    public FileInfo(String contentType, String downloadUri, String name, Long size, Date uploadDate, String folderName) {
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
