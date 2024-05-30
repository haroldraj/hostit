package com.train.hostitstorage.service;

import io.minio.*;
import io.minio.errors.*;
import io.minio.http.Method;
import io.minio.messages.Item;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
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
    public CompletableFuture<String> uploadFile(MultipartFile file, String filePath) {
        String baseFolderName = filePath.split("/")[0];
        try {
            Iterable<Result<Item>> results = minioClient.listObjects(
                    ListObjectsArgs.builder().bucket(bucketName).prefix(baseFolderName+"/").recursive(true).build());

            if (!results.iterator().hasNext()) {
                minioClient.putObject(
                        PutObjectArgs.builder().bucket(bucketName).object(baseFolderName + "/.init").stream(
                                new ByteArrayInputStream(new byte[0]), 0, -1).build());
            }

            //String fileName = userFolder+"/"+ file.getOriginalFilename();
            InputStream inputStream = new ByteArrayInputStream(file.getBytes());
            minioClient.putObject(
                    PutObjectArgs.builder().bucket(bucketName).object(filePath).stream(
                            inputStream, -1, 10485760).contentType(file.getContentType()).build());
            String filepath = filePath.replaceFirst(baseFolderName + "/", "");
            return CompletableFuture.completedFuture(filepath);
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

    public boolean createFolder(String folderName) throws Exception {
        // Extract the base folder name (e.g., "user-1") from the folderName
        try {
            String baseFolderName = folderName.split("/")[0];

            // Check if the base folder exists
            Iterable<Result<Item>> results = minioClient.listObjects(
                    ListObjectsArgs.builder().bucket(bucketName).prefix(baseFolderName + "/").recursive(true).build());

            // If the base folder does not exist, create it
            if (!results.iterator().hasNext()) {
                minioClient.putObject(
                        PutObjectArgs.builder().bucket(bucketName).object(baseFolderName + "/.init").stream(
                                new ByteArrayInputStream(new byte[0]), 0, -1).build());
            }

            // Create the specified folder (this could be a subfolder)
            minioClient.putObject(
                    PutObjectArgs.builder().bucket(bucketName).object(folderName + "/").stream(
                            new ByteArrayInputStream(new byte[0]), 0, -1).build());
            return true;
        } catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public Iterable<Result<Item>> listObjectsInFolder(String folderPath) throws ServerException, InsufficientDataException, ErrorResponseException, IOException, NoSuchAlgorithmException, InvalidKeyException, InvalidResponseException, XmlParserException, InternalException {
        List<String> objects = new ArrayList<>();
        Iterable<Result<Item>> results = minioClient.listObjects(
                ListObjectsArgs.builder().bucket(bucketName).prefix(folderPath+"/").recursive(false).build());

     /*   for (Result<Item> result : results) {
            Item item = result.get();
            objects.add(item.objectName());
        }*/

        return results;
    }

}