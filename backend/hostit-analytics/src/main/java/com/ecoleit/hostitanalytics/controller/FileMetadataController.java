package com.ecoleit.hostitanalytics.controller;

import com.ecoleit.hostitanalytics.entitie.FileMetadata; // Ensure the package name 'entitie' is correct. Typically, it should be 'entities'.
import com.ecoleit.hostitanalytics.service.FileMetadataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/files")
public class FileMetadataController {

    private final FileMetadataService fileMetadataService;

    @Autowired
    public FileMetadataController(FileMetadataService fileMetadataService) {
        this.fileMetadataService = fileMetadataService;
    }

    /**
     * Endpoint to retrieve all file metadata.
     * @return List of FileMetadata
     */
    @GetMapping
    public ResponseEntity<List<FileMetadata>> getAllFileMetadata() {
        List<FileMetadata> fileMetadataList = fileMetadataService.findAll();
        return ResponseEntity.ok(fileMetadataList);
    }

    /**
     * Endpoint to download all file metadata as a CSV file.
     * @param response HttpServletResponse for setting file download headers
     * @throws IOException if there is an error writing the CSV file
     */
    @GetMapping("/csv")
    public ResponseEntity<Void> downloadFileMetadataCsv(HttpServletResponse response) throws IOException {
        fileMetadataService.writeMetadataToCsv(response.getWriter());
        return ResponseEntity.noContent().build();
    }

}
