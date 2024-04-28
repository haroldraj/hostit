package com.train.hostit_synchro.dto;

public class FileSyncStatusDto {

    private String fileName;
    private String status;
    private String detailMessage;

    // Default constructor for deserialization
    public FileSyncStatusDto() {
    }

    // Parametrized constructor for easy instantiation
    public FileSyncStatusDto(String fileName, String status, String detailMessage) {
        this.fileName = fileName;
        this.status = status;
        this.detailMessage = detailMessage;
    }

    // Getters and Setters
    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDetailMessage() {
        return detailMessage;
    }

    public void setDetailMessage(String detailMessage) {
        this.detailMessage = detailMessage;
    }

    // Overriding toString() is helpful for logging purposes
    @Override
    public String toString() {
        return "FileSyncStatusDto{" +
                "fileName='" + fileName + '\'' +
                ", status='" + status + '\'' +
                ", detailMessage='" + detailMessage + '\'' +
                '}';
    }
}
