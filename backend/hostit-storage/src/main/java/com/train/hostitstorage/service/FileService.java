package com.train.hostitstorage.service;

import com.train.hostitstorage.dto.FileDownloadResponse;
import com.train.hostitstorage.dto.FileUploadResponse;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileService {

    private final MinioService minioService;

    public FileService(MinioService minioService) {
        this.minioService = minioService;
    }

    public FileUploadResponse uploadFile(MultipartFile file) {
        // Implement file upload logic using MinioService
        // For example:
        FileUploadResponse response = new FileUploadResponse();
        response.setMessage("File uploaded successfully");
        response.setFileName(file.getOriginalFilename());
        response.setFileSize(file.getSize());
        response.setContentType(file.getContentType());
        String fileName = file.getOriginalFilename();
        String contentType = file.getContentType();
        long fileSize = file.getSize(); // get the size of the file
        // Upload file to MinIO
        minioService.uploadFile(file);
        return response;
    }

    public FileDownloadResponse downloadFile(String fileName) {
        // Implement file download logic using MinioService
        // For example:
        byte[] fileContent = minioService.downloadFile(fileName);
        String contentType = minioService.getFileContentType(fileName);
        return new FileDownloadResponse(fileName, contentType, fileContent);
    }

    public boolean deleteFile(String fileName) {
        // Implement file deletion logic using MinioService
        // For example:
        return minioService.deleteFile(fileName);
    }

    public boolean fileExists(String fileName) {
        // Implement logic to check if a file exists using MinioService
        // For example:
        return minioService.fileExists(fileName);
    }

    public String getFileUrl(String fileName) {
        // Implement logic to get the URL of a file using MinioService
        // For example:
        return minioService.getFileUrl(fileName);
    }

    public long getFileSize(String fileName) {
        // Implement logic to get the size of a file using MinioService
        // For example:
        return minioService.getFileSize(fileName);
    }

    public String getFileContentType(String fileName) {
        // Implement logic to get the content type of a file using MinioService
        // For example:
        return minioService.getFileContentType(fileName);
    }

    // You can add more methods here for additional file management operations
}