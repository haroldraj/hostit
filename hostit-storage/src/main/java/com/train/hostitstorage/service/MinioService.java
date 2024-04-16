package com.train.hostitstorage.service;

import io.minio.MinioClient;
import io.minio.errors.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

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

    public MinioService() throws InvalidPortException, InvalidEndpointException {
        this.minioClient = new MinioClient(minioUrl, accessKey, secretKey);
    }

    public String uploadFile(MultipartFile file) {
        try {
            String fileName = file.getOriginalFilename();
            InputStream inputStream = new ByteArrayInputStream(file.getBytes());
            minioClient.putObject(bucketName, fileName, inputStream, file.getContentType());
            return minioClient.getObjectUrl(bucketName, fileName);
        } catch (IOException | InvalidKeyException | NoSuchAlgorithmException | InvalidBucketNameException | InsufficientDataException | NoResponseException | ErrorResponseException | InternalException | RegionConflictException | XmlParserException e) {
            e.printStackTrace();
            // Handle exception appropriately
            return null;
        }
    }

    public byte[] downloadFile(String fileName) {
        try {
            InputStream stream = minioClient.getObject(bucketName, fileName);
            return stream.readAllBytes();
        } catch (IOException | InvalidKeyException | NoSuchAlgorithmException | InvalidBucketNameException | InsufficientDataException | NoResponseException | ErrorResponseException | InternalException | InvalidArgumentException | InvalidResponseException | XmlParserException e) {
            e.printStackTrace();
            // Handle exception appropriately
            return null;
        }
    }

    public boolean deleteFile(String fileName) {
        try {
            minioClient.removeObject(bucketName, fileName);
            return true;
        } catch (IOException | InvalidKeyException | NoSuchAlgorithmException | InvalidBucketNameException | InsufficientDataException | NoResponseException | ErrorResponseException | InternalException | InvalidArgumentException | InvalidResponseException | XmlParserException e) {
            e.printStackTrace();
            // Handle exception appropriately
            return false;
        }
    }

    public boolean fileExists(String fileName) {
        try {
            return minioClient.statObject(bucketName, fileName) != null;
        } catch (IOException | InvalidKeyException | NoSuchAlgorithmException | InvalidBucketNameException | InsufficientDataException | NoResponseException | ErrorResponseException | InternalException | InvalidArgumentException | InvalidResponseException | XmlParserException e) {
            e.printStackTrace();
            // Handle exception appropriately
            return false;
        }
    }

    public String getFileUrl(String fileName) {
        return minioClient.getObjectUrl(bucketName, fileName);
    }

    public long getFileSize(String fileName) {
        try {
            return minioClient.statObject(bucketName, fileName).size();
        } catch (IOException | InvalidKeyException | NoSuchAlgorithmException | InvalidBucketNameException | InsufficientDataException | NoResponseException | ErrorResponseException | InternalException | InvalidArgumentException | InvalidResponseException | XmlParserException e) {
            e.printStackTrace();
            // Handle exception appropriately
            return -1;
        }
    }

    public String getFileContentType(String fileName) {
        try {
            return minioClient.statObject(bucketName, fileName).contentType();
        } catch (IOException | InvalidKeyException | NoSuchAlgorithmException | InvalidBucketNameException | InsufficientDataException | NoResponseException | ErrorResponseException | InternalException | InvalidArgumentException | InvalidResponseException | XmlParserException e) {
            e.printStackTrace();
            // Handle exception appropriately
            return null;
        }
    }

}
