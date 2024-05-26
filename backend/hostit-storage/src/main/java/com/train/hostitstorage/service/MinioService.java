package com.train.hostitstorage.service;

import io.minio.*;
import io.minio.http.Method;
import io.minio.messages.Item;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.http.HttpHeaders;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class MinioService {

    @Value("${minio.bucketName}")
    private String bucketName;

    @Value("${metadata.uri.download.expiration}")
    private int downloadUriExpiration;

    private final MinioClient minioClient;

    public MinioService(MinioClient minioClient) {
        this.minioClient = minioClient;
    }

    @Async
    public CompletableFuture<String> uploadFile(MultipartFile file, String userFolder) {
        try {
            Iterable<Result<Item>> results = minioClient.listObjects(
                    ListObjectsArgs.builder().bucket(bucketName).prefix(userFolder+"/").recursive(true).build());

            if (!results.iterator().hasNext()) {
                minioClient.putObject(
                        PutObjectArgs.builder().bucket(bucketName).object(userFolder + "/.init").stream(
                                new ByteArrayInputStream(new byte[0]), 0, -1).build());
            }

           // String fileName = userFolder+"/"+ file.getOriginalFilename();
            String fileName = userFolder+"/"+ file.getOriginalFilename();
            InputStream inputStream = new ByteArrayInputStream(file.getBytes());
            minioClient.putObject(
                    PutObjectArgs.builder().bucket(bucketName).object(fileName).stream(
                            inputStream, -1, 10485760).contentType(file.getContentType()).build());
            return CompletableFuture.completedFuture(file.getOriginalFilename());
        } catch (Exception e) {
            e.printStackTrace();
            return CompletableFuture.completedFuture(null);
        }
    }

    public boolean deleteFile(String filePath) {
        try {
            minioClient.removeObject(
                    RemoveObjectArgs.builder().bucket(bucketName).object(filePath).build());
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

    public String generateDownloadUri(String filepath) {
        try {
            if (!fileExists(filepath)) {
                throw new Exception("File with name "+ filepath +" doesn't exist");
            }
            String downloadUri = minioClient.getPresignedObjectUrl(
                    GetPresignedObjectUrlArgs.builder()
                            .method(Method.GET)
                            .bucket(bucketName)
                            .object(filepath)
                            .expiry(downloadUriExpiration)
                            .build());
            System.out.println("Generated URI: " + downloadUri); // Print the generated URI
            return downloadUri;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}