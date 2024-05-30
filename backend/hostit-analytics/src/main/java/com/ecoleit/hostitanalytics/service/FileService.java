package com.ecoleit.hostitanalytics.service;

import com.ecoleit.hostitanalytics.dto.FileDTO;
import com.ecoleit.hostitanalytics.model.FileInfo;
import com.ecoleit.hostitanalytics.repository.FileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class FileService {

    private final FileRepository fileRepository;

    @Autowired
    public FileService(FileRepository fileRepository) {
        this.fileRepository = fileRepository;
    }

    // Retrieve all files
    public List<FileInfo> findAllFiles() {
        return fileRepository.findAll();
    }

    // Find a single file by ID
    public FileInfo findFileById(Long id) {
        return fileRepository.findById(id).orElseThrow(() -> new RuntimeException("File not found"));
    }

    // Create a new file
    @Transactional
    public FileInfo createFile(FileDTO fileDto) {
        FileInfo fileInfo = new FileInfo();
        fileInfo.setName(fileDto.getName());
        fileInfo.setContentType(fileDto.getContentType());
        fileInfo.setSize(fileDto.getSize());
        fileInfo.setUploadDate(fileDto.getUploadDate());
        fileInfo.setFolderName(fileDto.getFolderName());
        return fileRepository.save(fileInfo);
    }

    // Update existing file
    @Transactional
    public FileInfo updateFile(Long id, FileDTO fileDto) {
        FileInfo fileInfo = fileRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("File not found"));

        fileInfo.setName(fileDto.getName());
        fileInfo.setContentType(fileDto.getContentType());
        fileInfo.setSize(fileDto.getSize());
        fileInfo.setUploadDate(fileDto.getUploadDate());
        fileInfo.setFolderName(fileDto.getFolderName());
        return fileRepository.save(fileInfo);
    }

    // Delete a file
    @Transactional
    public void deleteFile(Long id) {
        FileInfo fileInfo = fileRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("File not found"));
        fileRepository.delete(fileInfo);
    }
}
