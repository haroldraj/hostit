package com.train.hostitstorage.controller;

<<<<<<< HEAD
import com.train.hostitstorage.entity.FileMetadata;
=======
import com.train.hostitstorage.model.FileDTO;
import com.train.hostitstorage.model.FileUploadDTO;
>>>>>>> hostit_storage
import com.train.hostitstorage.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.CompletableFuture;

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
<<<<<<< HEAD
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

    @GetMapping("/all/files")
    public ResponseEntity<Map<String, Object>> getAllUserFiles() {
        List<FileMetadata> files = fileService.getAllUserFiles();
        Map<String, Object> response = new HashMap<>();
        response.put("result", files);
        return ResponseEntity.ok(response);
    }
=======
    public CompletableFuture<FileDTO> uploadFile(@RequestBody FileUploadDTO fileUploadDTO) throws IOException {
        return fileService.uploadFileAndSaveMetadata(fileUploadDTO);
    }

    @GetMapping("/files")
    public ResponseEntity<List<FileDTO>> listFiles(@RequestParam(required = false) String directory) {
        try {
            List<FileDTO> files = fileService.listFiles(directory);
            return ResponseEntity.ok(files);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteFile(@PathVariable int id) {
        try {
            boolean deleted = fileService.deleteFile(id);
            if (deleted) {
                return ResponseEntity.ok("File deleted successfully.");
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("File not found.");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error deleting file: " + e.getMessage());
        }
    }

    @PostMapping("/create-directory")
    public ResponseEntity<String> createDirectory(@RequestParam String directoryPath) {
        try {
            fileService.createDirectory(directoryPath);
            return ResponseEntity.ok("Directory created successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to create directory: " + e.getMessage());
        }
    }

>>>>>>> hostit_storage

}
