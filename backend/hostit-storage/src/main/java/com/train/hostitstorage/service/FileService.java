package com.train.hostitstorage.service;

import com.train.hostitstorage.HostitStorageApplication;
import com.train.hostitstorage.entity.File;
import com.train.hostitstorage.model.FileDTO;
import com.train.hostitstorage.model.FileUploadDTO;
import com.train.hostitstorage.repository.FileRepository;
import io.minio.DownloadObjectArgs;
import io.minio.MinioClient;
import io.minio.UploadObjectArgs;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

@Service
public class FileService {
    private  final FileRepository fileRepository;
    private final MinioClient minioClient;
    private  final String bucketName = "hostit";
    static Logger logger =  LoggerFactory.getLogger(HostitStorageApplication .class);

    public FileService(FileRepository fileRepository, MinioClient minioClient){
        this.fileRepository = fileRepository;
        this.minioClient = minioClient;
    }

    public CompletableFuture<FileDTO> uploadFileAndSaveMetadata(FileUploadDTO fileUploadDTO) throws IOException {
        Optional<File> optionalFile = fileRepository.findByObjectName(fileUploadDTO.objectName());
        if(optionalFile.isEmpty()){
        UploadObjectArgs uploadObjectArgs = UploadObjectArgs.builder()
                .bucket(fileUploadDTO.bucketName())
                .object(fileUploadDTO.objectName())
                .filename(fileUploadDTO.fileName())
                .contentType(fileUploadDTO.contentType())
                .build();

        return CompletableFuture.supplyAsync(() -> {
            try {
                return minioClient.uploadObject(uploadObjectArgs);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }).thenApply(response -> {
            File newFile = new File();
            newFile.setObjectName(response.object());
            newFile.setObjectSize(fileUploadDTO.objectSize());
            newFile.setContentType(fileUploadDTO.contentType());
            newFile.setBucketName(response.bucket());
            newFile.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            File savedFile = fileRepository.save(newFile);

            return new FileDTO(
                    savedFile.getId(),
                    savedFile.getObjectName(),
                    savedFile.getContentType(),
                    savedFile.getBucketName(),
                    savedFile.getObjectSize(),
                    savedFile.getCreatedAt());
        }).exceptionally(e -> {
            logger.error("Error occurred: ", e);
            return null;
        });
    } else{
            throw new RuntimeException("File already exists");
        }
    }
    private static void downloadFile(MinioClient minioClient) throws Exception{
        String bucketName = "create-bucket-test";
        String objectName = "logo_hostit.png";
        String fileName = "/home/harold/Pictures/logo_hostit.png";
        DownloadObjectArgs downloadObjectArgs = DownloadObjectArgs.builder()
                .bucket(bucketName)
                .object(objectName)
                .filename(fileName)
                .build();
        minioClient.downloadObject(downloadObjectArgs);
    }
}
