package com.train.hostitstorage.service;

import io.minio.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

@Service
public class MinioService {

    @Value("${minio.url}")
    private String minioUrl;

    @Value("${minio.accessKey}")
    private String accessKey;

    @Value("${minio.secretKey}")
    private String secretKey;

    @Value("${minio.bucketName}")
    private String bucketName;

    private final MinioClient minioClient;

    public MinioService(MinioClient minioClient) {
        this.minioClient = minioClient;
    }


    public String uploadFile(MultipartFile file) {
        try {
            String fileName = file.getOriginalFilename();
            InputStream inputStream = new ByteArrayInputStream(file.getBytes());
            minioClient.putObject(
                    PutObjectArgs.builder().bucket(bucketName).object(fileName).stream(
                            inputStream, -1, 10485760).contentType(file.getContentType()).build());
            return minioUrl + "/" + bucketName + "/" + fileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public byte[] downloadFile(String fileName) {
        try {
            InputStream stream = minioClient.getObject(
                    GetObjectArgs.builder().bucket(bucketName).object(fileName).build());
            return stream.readAllBytes();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean deleteFile(String fileName) {
        try {
            minioClient.removeObject(
                    RemoveObjectArgs.builder().bucket(bucketName).object(fileName).build());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean fileExists(String fileName) {
        try {
            minioClient.statObject(
                    StatObjectArgs.builder().bucket(bucketName).object(fileName).build());
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getFileUrl(String fileName) {
        return minioUrl + "/" + bucketName + "/" + fileName;
    }

    public long getFileSize(String fileName) {
        try {
            return minioClient.statObject(
                    StatObjectArgs.builder().bucket(bucketName).object(fileName).build()).size();
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public String getFileContentType(String fileName) {
        try {
            return minioClient.statObject(
                    StatObjectArgs.builder().bucket(bucketName).object(fileName).build()).contentType();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}