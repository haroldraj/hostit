package com.train.hostitstorage.controller;

import com.train.hostitstorage.entity.FileMetadata;
import com.train.hostitstorage.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/storage")
public class FileController {

    private final FileService fileService;

    @Autowired
    public FileController(FileService fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload")
    public ResponseEntity  uploadFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam("userId") Long userId) {
        try {
            return ResponseEntity.ok(fileService.uploadFile(file, userId));
        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity deleteFile(
            @RequestParam("filePath") String filePath,
            @RequestParam("userId") Long userId){
        try {
            boolean isFileDeleted = fileService.deleteFile(userId, filePath);
            if (isFileDeleted) {
                return ResponseEntity.ok("File deleted successfully");
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("File not found");
            }
        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/download")
    public ResponseEntity downloadFile(
            @RequestParam("filePath") String filePath,
            @RequestParam("userId") Long userId){
        try {
            return ResponseEntity.ok(fileService.getFileDownloadUri(userId, filePath));
        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/files")
    public ResponseEntity<Map<String, Object>> getUserFiles(
            @RequestParam("userId") Long userId) {
        List<FileMetadata> files = fileService.getUserFiles(userId);
        Map<String, Object> response = new HashMap<>();
        response.put("result", files);
        response.put("folderName",  "user-" + userId);
        return ResponseEntity.ok(response);
    }
}
