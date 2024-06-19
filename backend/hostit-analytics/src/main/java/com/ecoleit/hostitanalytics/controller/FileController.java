package com.ecoleit.hostitanalytics.controller;

import com.ecoleit.hostitanalytics.dto.FileDTO;
import com.ecoleit.hostitanalytics.model.FileInfo;
import com.ecoleit.hostitanalytics.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

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

    // Endpoint to get file size percentage per user
    @GetMapping("/size-percentage-per-user")
    public ResponseEntity<Map<Long, Double>> getFileSizePercentagePerUser() {
        return ResponseEntity.ok(fileService.getFileSizePercentagePerUser());
    }

    // Endpoint to get file type percentage per user
    @GetMapping("/type-percentage-per-user")
    public ResponseEntity<Map<Long, Map<String, Double>>> getFileTypePercentagePerUser() {
        return ResponseEntity.ok(fileService.getFileTypePercentagePerUser());
    }

    // Endpoint to get overall file size percentage
    @GetMapping("/size-percentage-overall")
    public ResponseEntity<Map<String, Double>> getOverallFileSizePercentage() {
        return ResponseEntity.ok(fileService.getOverallFileSizePercentage());
    }

    // Endpoint to get overall file type percentage
    @GetMapping("/type-percentage-overall")
    public ResponseEntity<Map<String, Double>> getOverallFileTypePercentage() {
        return ResponseEntity.ok(fileService.getOverallFileTypePercentage());
    }

    // Endpoint to get file size percentage per folder per user
    @GetMapping("/size-percentage-per-folder-per-user")
    public ResponseEntity<Map<Long, Map<String, Double>>> getFileSizePercentagePerFolderPerUser() {
        return ResponseEntity.ok(fileService.getFileSizePercentagePerFolderPerUser());
    }

    // Endpoint to get file type percentage per folder per user
    @GetMapping("/type-percentage-per-folder-per-user")
    public ResponseEntity<Map<Long, Map<String, Double>>> getFileTypePercentagePerFolderPerUser() {
        return ResponseEntity.ok(fileService.getFileTypePercentagePerFolderPerUser());
    }

    // Endpoint to get average data usage per user
    @GetMapping("/average-data-usage-per-user")
    public ResponseEntity<Double> getAverageDataUsagePerUser() {
        return ResponseEntity.ok(fileService.getAverageDataUsagePerUser());
    }

    // Endpoint to get average file size by category
    @GetMapping("/average-file-size-by-category")
    public ResponseEntity<Map<String, Double>> getAverageFileSizeByCategory() {
        return ResponseEntity.ok(fileService.getAverageFileSizeByCategory());
    }

    // Endpoint to get file quantity by directory
    @GetMapping("/file-quantity-by-directory")
    public ResponseEntity<Map<String, Integer>> getFileQuantityByDirectory() {
        return ResponseEntity.ok(fileService.getFileQuantityByDirectory());
    }

    // Endpoint to get file quantity by user
    @GetMapping("/file-quantity-by-user")
    public ResponseEntity<Map<Long, Integer>> getFileQuantityByUser() {
        return ResponseEntity.ok(fileService.getFileQuantityByUser());
    }

    // Endpoint to classify users
    @GetMapping("/classify-users")
    public ResponseEntity<Map<Long, String>> classifyUsers() {
        return ResponseEntity.ok(fileService.classifyUsers());
    }
}
