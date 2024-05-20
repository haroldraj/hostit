package com.train.hostitstorage.service;

import com.train.hostitstorage.HostitStorageApplication;
import com.train.hostitstorage.entity.File;
import com.train.hostitstorage.model.FileDTO;
import com.train.hostitstorage.model.FileUploadDTO;
import com.train.hostitstorage.repository.FileRepository;
import io.minio.*;
import io.minio.messages.Item;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class FileService {
    private final FileRepository fileRepository;
    private final MinioClient minioClient;
    private static final Logger logger = LoggerFactory.getLogger(HostitStorageApplication.class);

    public FileService(FileRepository fileRepository, MinioClient minioClient) {
        this.fileRepository = fileRepository;
        this.minioClient = minioClient;
    }

    public CompletableFuture<FileDTO> uploadFileAndSaveMetadata(FileUploadDTO fileUploadDTO) throws IOException {
        Optional<File> optionalFile = fileRepository.findByObjectName(fileUploadDTO.objectName());
        if (optionalFile.isPresent()) {
            throw new RuntimeException("File already exists");
        }

        UploadObjectArgs uploadObjectArgs = UploadObjectArgs.builder()
                .bucket(fileUploadDTO.bucketName())
                .object(fileUploadDTO.objectName())
                .filename(fileUploadDTO.fileName())
                .contentType(fileUploadDTO.contentType())
                .build();

        return CompletableFuture.supplyAsync(() -> {
            try {
                minioClient.uploadObject(uploadObjectArgs);
                File newFile = new File();
                newFile.setObjectName(fileUploadDTO.objectName());
                newFile.setObjectSize(fileUploadDTO.objectSize());
                newFile.setContentType(fileUploadDTO.contentType());
                newFile.setBucketName(fileUploadDTO.bucketName());
                newFile.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                File savedFile = fileRepository.save(newFile);

                return new FileDTO(
                        savedFile.getId(),
                        savedFile.getObjectName(),
                        savedFile.getContentType(),
                        savedFile.getBucketName(),
                        savedFile.getObjectSize(),
                        savedFile.getCreatedAt());
            } catch (Exception e) {
                logger.error("Error during file upload and metadata saving: ", e);
                throw new RuntimeException(e);
            }
        });
    }

    public List<FileDTO> listFiles(String bucketName) throws Exception {
        Iterable<Result<Item>> results = minioClient.listObjects(
                ListObjectsArgs.builder().bucket(bucketName).build());
        return StreamSupport.stream(results.spliterator(), false)
                .map(result -> {
                    try {
                        Item item = result.get();
                        return new FileDTO(null, item.objectName(), null, bucketName, item.size(), null);
                    } catch (Exception e) {
                        logger.error("Error reading item from Minio", e);
                        return null;
                    }
                })
                .collect(Collectors.toList());
    }

    public boolean deleteFile(int fileId) {
        Optional<File> fileOptional = fileRepository.findById(fileId);
        if (fileOptional.isPresent()) {
            File file = fileOptional.get();
            try {
                minioClient.removeObject(
                        RemoveObjectArgs.builder()
                                .bucket(file.getBucketName())
                                .object(file.getObjectName())
                                .build());
                fileRepository.delete(file);
                return true;
            } catch (Exception e) {
                logger.error("Error deleting file from Minio: ", e);
                return false;
            }
        }
        return false;
    }

    public void createDirectory(String directoryPath) {
        // Note: Minio does not support creating empty directories; directories are "created" upon first file upload.
    }
}
