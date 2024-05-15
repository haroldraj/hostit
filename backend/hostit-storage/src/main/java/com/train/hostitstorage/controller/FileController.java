package com.train.hostitstorage.controller;

import com.train.hostitstorage.entity.FileMetadata;
import com.train.hostitstorage.model.FileDownloadResponse;
import com.train.hostitstorage.model.FileUploadResponse;
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
    public ResponseEntity uploadFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam("userId") String userId) {
        try {
            return ResponseEntity.ok(fileService.uploadFile(file, userId));
        } catch (Exception e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/download/{fileName:.+}")
    public ResponseEntity<byte[]> downloadFile(@PathVariable String fileName) {
        try {
            FileDownloadResponse response = fileService.downloadFile(fileName);
            byte[] fileData = response.getFileData();
            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=\"" + fileName + "\"")
                    .body(fileData);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping("/user-{userId}/files")
    public List<FileMetadata> getUserFiles(@PathVariable String userId) {
        return fileService.getUserFiles(userId);
    }
}
