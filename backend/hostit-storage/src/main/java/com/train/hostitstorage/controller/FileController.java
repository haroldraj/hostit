package com.train.hostitstorage.controller;
import com.train.hostitstorage.entity.FileMetadata;
import com.train.hostitstorage.service.FileService;
import com.train.hostitstorage.service.CsvService;  // Import the CSV service
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/storage")
public class FileController {
    private final FileService fileService;
    private final CsvService csvService;  // Add a reference to the CSV service

    @Autowired
    public FileController(FileService fileService, CsvService csvService) {  // Update constructor to include CsvService
        this.fileService = fileService;
        this.csvService = csvService;
    }

    @PostMapping("/upload")
    public ResponseEntity uploadFile(
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

    @GetMapping("/all/files")
    public ResponseEntity<Map<String, Object>> getAllUserFiles() {
        List<FileMetadata> files = fileService.getAllUserFiles();
        Map<String, Object> response = new HashMap<>();
        response.put("result", files);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/files/csv")
    public ResponseEntity<InputStreamResource> downloadCsv() {
        try {
            List<FileMetadata> files = fileService.getAllUserFiles(); // Get all files
            ByteArrayInputStream in = csvService.filesToCSV(files);  // Generate CSV
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=files.csv");  // Set filename in header
            return ResponseEntity.ok()
                    .headers(headers)
                    .contentType(MediaType.parseMediaType("text/csv"))
                    .body(new InputStreamResource(in));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
