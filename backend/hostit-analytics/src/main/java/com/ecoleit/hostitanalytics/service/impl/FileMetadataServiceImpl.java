package com.ecoleit.hostitanalytics.service.impl;

import com.ecoleit.hostitanalytics.entitie.FileMetadata;
import com.ecoleit.hostitanalytics.repository.FileMetadataRepository;
import com.ecoleit.hostitanalytics.service.FileMetadataService;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.io.Writer;
import java.util.List;

@Service
@Transactional
public class FileMetadataServiceImpl implements FileMetadataService {

    private final FileMetadataRepository fileMetadataRepository;

    @Autowired
    public FileMetadataServiceImpl(FileMetadataRepository fileMetadataRepository) {
        this.fileMetadataRepository = fileMetadataRepository;
    }

    @Override
    public List<FileMetadata> findAll() {
        return fileMetadataRepository.findAll();
    }

    @Override
    public void writeMetadataToCsv(Writer writer) {
        List<FileMetadata> metadataList = findAll();
        try (CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT
                .withHeader("ID", "User ID", "File Type", "File Size", "Upload Date", "Directory ID"))) {
            for (FileMetadata metadata : metadataList) {
                csvPrinter.printRecord(metadata.getId(), metadata.getUserId(), metadata.getFileType(), metadata.getFileSize(), metadata.getUploadDate(), metadata.getDirectoryId());
            }
        } catch (IOException e) {
            throw new RuntimeException("Failed to write CSV data", e);
        }
    }

    @Override
    public FileMetadata save(FileMetadata fileMetadata) {
        return fileMetadataRepository.save(fileMetadata);
    }

    @Override
    public FileMetadata findById(Long id) {
        return fileMetadataRepository.findById(id).orElse(null);
    }

    @Override
    public void deleteById(Long id) {
        fileMetadataRepository.deleteById(id);
    }
}
