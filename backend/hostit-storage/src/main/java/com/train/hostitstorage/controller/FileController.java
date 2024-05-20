package com.train.hostitstorage.controller;

import com.train.hostitstorage.model.FileDTO;
import com.train.hostitstorage.model.FileUploadDTO;
import com.train.hostitstorage.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/files")
public class FileController {
    private final FileService fileService;

    @Autowired
    public FileController(FileService fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload")
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


}
