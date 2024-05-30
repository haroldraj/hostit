package com.ecoleit.hostitanalytics.controller;

import com.ecoleit.hostitanalytics.dto.FileDTO;
import com.ecoleit.hostitanalytics.model.FileInfo;
import com.ecoleit.hostitanalytics.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/files")
public class FileController {

    private final FileService fileService;

    @Autowired
    public FileController(FileService fileService) {
        this.fileService = fileService;
    }

    // Endpoint to retrieve all files
    @GetMapping
    public ResponseEntity<List<FileInfo>> getAllFiles() {
        List<FileInfo> files = fileService.findAllFiles();
        return ResponseEntity.ok(files);
    }

    // Endpoint to retrieve a single file by ID
    @GetMapping("/{id}")
    public ResponseEntity<FileInfo> getFileById(@PathVariable Long id) {
        FileInfo file = fileService.findFileById(id);
        return ResponseEntity.ok(file);
    }

    // Endpoint to create a new file
    @PostMapping
    public ResponseEntity<FileInfo> createFile(@RequestBody FileDTO fileDto) {
        FileInfo file = fileService.createFile(fileDto);
        return ResponseEntity.ok(file);
    }

    // Endpoint to update an existing file
    @PutMapping("/{id}")
    public ResponseEntity<FileInfo> updateFile(@PathVariable Long id, @RequestBody FileDTO fileDto) {
        FileInfo updatedFile = fileService.updateFile(id, fileDto);
        return ResponseEntity.ok(updatedFile);
    }

    // Endpoint to delete a file
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteFile(@PathVariable Long id) {
        fileService.deleteFile(id);
        return ResponseEntity.ok("File deleted successfully");
    }
}
