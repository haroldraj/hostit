package com.train.hostitstorage.service;

import org.springframework.stereotype.Service;

@Service
public class FolderService {
    private final MinioService minioService;

    public FolderService(MinioService minioService) {
        this.minioService = minioService;
    }

    public String getUserFolder(Long userId) {
        return "user-" + userId.toString();
    }

    public boolean createFolder(Long userId, String folderPath) throws Exception {
        String fullPath = this.getUserFolder(userId) + "/" + folderPath;
        return minioService.createFolder(fullPath) ;
    }
}
