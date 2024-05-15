package com.train.hostitstorage.service;

import com.train.hostitstorage.entity.FileMetadata;
import com.train.hostitstorage.model.FileDownloadResponse;
import com.train.hostitstorage.model.FileUploadResponse;
import com.train.hostitstorage.repository.FileMetadataRepository;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.sql.Timestamp;

@Service
public class FileService {

    private final MinioService minioService;
    private final FileMetadataRepository fileMetadataRepository;

    public FileService(MinioService minioService, FileMetadataRepository fileMetadataRepository) {
        this.minioService = minioService;
        this.fileMetadataRepository = fileMetadataRepository;
    }

    public FileUploadResponse uploadFile(MultipartFile file) throws FileUploadException {
        FileUploadResponse response = new FileUploadResponse();
        String fileName = file.getOriginalFilename();

        if (minioService.fileExists(fileName)) {
            throw new FileUploadException("File already uploaded");
        }
        if (fileMetadataRepository.existsByName(fileName)) {
            throw new FileUploadException("File metadata already exists in the database");
        }
        boolean isUploaded = minioService.uploadFile(file);
        if (!isUploaded) {
            throw new FileUploadException("Failed to upload file");
        }
        response.setMessage("File uploaded successfully");
        response.setFileName(file.getOriginalFilename());
        response.setFileSize(file.getSize());
        response.setContentType(file.getContentType());

        FileMetadata fileMetadata = new FileMetadata();
        fileMetadata.setName(file.getOriginalFilename());
        fileMetadata.setSize(file.getSize());
        fileMetadata.setContentType(file.getContentType());
        fileMetadata.setUploadDate(new Timestamp(System.currentTimeMillis()));
        fileMetadataRepository.save(fileMetadata);

        return response;
    }

    public FileDownloadResponse downloadFile(String fileName) {
        byte[] fileContent = minioService.downloadFile(fileName);
        String contentType = minioService.getFileContentType(fileName);
        return new FileDownloadResponse(fileName, contentType, fileContent);
    }

    public boolean deleteFile(String fileName) {
        return minioService.deleteFile(fileName);
    }

    public String getFileUrl(String fileName) {
        return minioService.getFileUrl(fileName);
    }

    public long getFileSize(String fileName) {
        return minioService.getFileSize(fileName);
    }

    public String getFileContentType(String fileName) {
        return minioService.getFileContentType(fileName);
    }

}
