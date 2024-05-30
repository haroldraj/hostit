package com.train.hostitstorage.controller;

import com.train.hostitstorage.entity.FileMetadata;
import com.train.hostitstorage.model.FileDTO;
import com.train.hostitstorage.service.FolderService;
import io.minio.errors.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/storage/folder")
public class FolderController {
    private final FolderService folderService;

        @Autowired
    public FolderController(FolderService folderService) {
        this.folderService = folderService;
    }


    @PostMapping("/create")
    public ResponseEntity createFolder(
            @RequestParam("folderPath") String folderPath,
            @RequestParam("userId") Long userId) {
        try {
            boolean isFolderCreated = folderService.createFolder(userId, folderPath);
            if (isFolderCreated) {
                return ResponseEntity.ok("Folder created successfully");
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Path not found");
            }
        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
    @GetMapping("/list")
    public ResponseEntity getDistinctByUserIdAndFolderName(
            @RequestParam("folderName") String folderName,
            @RequestParam("userId") Long userId){
        List<FileMetadata> files = folderService.getDistinctByUserIdAndFolderName(userId, folderName);
        Map<String, Object> response = new HashMap<>();
        response.put("result", files);
        response.put("folderName",  "user-" + userId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/foldercontents")
    public ResponseEntity<List<FileDTO>> getFolderContents(
            @RequestParam("folderName") String folderName,
            @RequestParam("userId") Long userId) throws Exception {
        List<FileDTO> contents = folderService.getFilesAndFoldersInFolder(userId, folderName);
        return ResponseEntity.ok(contents);
    }
}
