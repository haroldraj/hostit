package com.train.hostitstorage.controller;

import com.train.hostitstorage.model.FileDTO;
import com.train.hostitstorage.model.FileUploadDTO;
import com.train.hostitstorage.service.FileService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/files")
public class FileController {
    private final FileService fileService;

    public FileController(FileService fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload")
    CompletableFuture<FileDTO> uploadFile(@RequestBody FileUploadDTO fileUploadDTO) throws IOException {
        return fileService.uploadFileAndSaveMetadata(fileUploadDTO);
    }

}
