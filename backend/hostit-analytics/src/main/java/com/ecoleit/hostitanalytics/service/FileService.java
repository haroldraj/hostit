package com.ecoleit.hostitanalytics.service;

import com.ecoleit.hostitanalytics.dto.FileDTO;
import com.ecoleit.hostitanalytics.model.FileInfo;
import com.ecoleit.hostitanalytics.repository.FileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

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

    // Calculate file size percentage per user
    public Map<Long, Double> getFileSizePercentagePerUser() {
        List<FileInfo> files = fileRepository.findAll();
        double totalSize = files.stream().mapToDouble(FileInfo::getSize).sum();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getUserId,
                        Collectors.summingDouble(FileInfo::getSize)))
                .entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, e -> (e.getValue() / totalSize) * 100));
    }

    // Calculate file type percentage per user
    public Map<Long, Map<String, Double>> getFileTypePercentagePerUser() {
        List<FileInfo> files = fileRepository.findAll();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getUserId,
                Collectors.groupingBy(FileInfo::getContentType,
                        Collectors.collectingAndThen(Collectors.counting(), count -> (double) count / files.size() * 100))));
    }

    // Calculate overall file size percentage
    public Map<String, Double> getOverallFileSizePercentage() {
        List<FileInfo> files = fileRepository.findAll();
        double totalSize = files.stream().mapToDouble(FileInfo::getSize).sum();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getContentType,
                        Collectors.summingDouble(FileInfo::getSize)))
                .entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, e -> (e.getValue() / totalSize) * 100));
    }

    // Calculate overall file type percentage
    public Map<String, Double> getOverallFileTypePercentage() {
        List<FileInfo> files = fileRepository.findAll();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getContentType,
                Collectors.collectingAndThen(Collectors.counting(), count -> (double) count / files.size() * 100)));
    }

    // Calculate file size percentage per folder per user
    public Map<Long, Map<String, Double>> getFileSizePercentagePerFolderPerUser() {
        List<FileInfo> files = fileRepository.findAll();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getUserId,
                Collectors.groupingBy(FileInfo::getFolderName,
                        Collectors.collectingAndThen(Collectors.summingDouble(FileInfo::getSize), size -> (size / files.stream().mapToDouble(FileInfo::getSize).sum()) * 100))));
    }

    // Calculate file type percentage per folder per user
    public Map<Long, Map<String, Double>> getFileTypePercentagePerFolderPerUser() {
        List<FileInfo> files = fileRepository.findAll();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getUserId,
                Collectors.groupingBy(FileInfo::getFolderName,
                        Collectors.collectingAndThen(Collectors.counting(), count -> (double) count / files.size() * 100))));
    }

    // Calculate average data usage per user
    public double getAverageDataUsagePerUser() {
        List<FileInfo> files = fileRepository.findAll();
        double totalSize = files.stream().mapToDouble(FileInfo::getSize).sum();
        long userCount = files.stream().map(FileInfo::getUserId).distinct().count();
        return totalSize / userCount;
    }

    // Calculate average file size by category
    public Map<String, Double> getAverageFileSizeByCategory() {
        List<FileInfo> files = fileRepository.findAll();
        Map<String, Double> categorySizes = new HashMap<>();

        double size0to5MB = files.stream().filter(file -> file.getSize() <= 5 * 1024 * 1024).mapToDouble(FileInfo::getSize).average().orElse(0.0);
        double size5MBto1GB = files.stream().filter(file -> file.getSize() > 5 * 1024 * 1024 && file.getSize() <= 1024 * 1024 * 1024).mapToDouble(FileInfo::getSize).average().orElse(0.0);
        double size1GBto5GB = files.stream().filter(file -> file.getSize() > 1024 * 1024 * 1024 && file.getSize() <= 5 * 1024 * 1024 * 1024).mapToDouble(FileInfo::getSize).average().orElse(0.0);
        double sizeAbove5GB = files.stream().filter(file -> file.getSize() > 5 * 1024 * 1024 * 1024).mapToDouble(FileInfo::getSize).average().orElse(0.0);

        categorySizes.put("0MB - 5MB", size0to5MB);
        categorySizes.put("5MB - 1GB", size5MBto1GB);
        categorySizes.put("1GB - 5GB", size1GBto5GB);
        categorySizes.put(">5GB", sizeAbove5GB);

        return categorySizes;
    }

    // Calculate file quantity by directory
    public Map<String, Integer> getFileQuantityByDirectory() {
        List<FileInfo> files = fileRepository.findAll();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getFolderName,
                Collectors.collectingAndThen(Collectors.counting(), Long::intValue)));
    }

    // Calculate file quantity by user
    public Map<Long, Integer> getFileQuantityByUser() {
        List<FileInfo> files = fileRepository.findAll();
        return files.stream().collect(Collectors.groupingBy(FileInfo::getUserId,
                Collectors.collectingAndThen(Collectors.counting(), Long::intValue)));
    }


    // Classify users based on file uploads
    public Map<Long, String> classifyUsers() {
        List<FileInfo> files = fileRepository.findAll();
        Map<Long, Long> userFileSizes = files.stream()
                .collect(Collectors.groupingBy(FileInfo::getUserId, Collectors.summingLong(FileInfo::getSize)));

        return userFileSizes.entrySet().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, entry -> {
                    if (entry.getValue() > 30 * 1024 * 1024) {
                        return "Huge Video Storage";
                    } else if (entry.getValue() > 10 * 1024 * 1024) {
                        return "Tech-Savvy";
                    } else {
                        return "Non Tech-Savvy";
                    }
                }));
    }
}
