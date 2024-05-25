package com.ecoleit.hostitanalytics.controller;

import com.ecoleit.hostitanalytics.model.FileMetadata;
import com.ecoleit.hostitanalytics.service.FileMetadataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class FileMetadataViewController {

    @Autowired
    private FileMetadataService fileMetadataService;

    @GetMapping("/view-metadata")
    public String showFileMetadata(Model model) {
        List<FileMetadata> metadataList = fileMetadataService.findAll();
        model.addAttribute("metadataList", metadataList);
        return "filemetadata";  // Name of the Thymeleaf template
    }
}
