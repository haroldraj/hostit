package com.train.hostitstorage.service;

import com.train.hostitstorage.entity.FileMetadata;
import com.train.hostitstorage.model.FileDTO;
import com.train.hostitstorage.repository.FileMetadataRepository;
import io.minio.Result;
import io.minio.errors.*;
import io.minio.messages.Item;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class FolderService {
    private final MinioService minioService;
    private final FileMetadataRepository fileMetadataRepository;

    public FolderService(MinioService minioService, FileMetadataRepository fileMetadataRepository) {
        this.minioService = minioService;
        this.fileMetadataRepository = fileMetadataRepository;
    }

    public String getUserFolder(Long userId) {
        return "user-" + userId.toString();
    }

    public boolean createFolder(Long userId, String folderPath) throws Exception {
        String fullPath = this.getUserFolder(userId) + "/" + folderPath;
        return minioService.createFolder(fullPath) ;
    }

    public List<FileMetadata> getDistinctByUserIdAndFolderName(Long userId, String folderName) {
        return fileMetadataRepository.findDistinctByUserIdAndFolderName(userId, folderName);
    }

    public List<FileDTO> getFilesAndFoldersInFolder(Long userId, String folderName) throws ServerException, InsufficientDataException, ErrorResponseException, IOException, NoSuchAlgorithmException, InvalidKeyException, InvalidResponseException, XmlParserException, InternalException {
        String userFolder ="user-" + userId.toString();
        String folder;
        if(Objects.equals(folderName, ".root")){
            folder = userFolder;
        }else{
            folder = userFolder+ "/" + folderName;
        }
        Iterable<Result<Item>> objects = minioService.listObjectsInFolder(folder);
        List<Result<Item>> filteredObjects = StreamSupport.stream(objects.spliterator(), false)
                .filter(result -> {
                    try {
                        return !result.get().objectName().endsWith(".init");
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .toList();
        return filteredObjects.stream()
                .map(result -> {
                    try {
                        FileDTO fileDTO= new FileDTO(result.get(), userFolder);
                        return  fileDTO;
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .collect(Collectors.toList());
    }
}
