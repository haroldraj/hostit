package com.ecoleit.hostitanalytics.repository;

import com.ecoleit.hostitanalytics.entitie.FileMetadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long> {

    // Here you can define custom query methods, e.g., find by file type, user id, etc.
    // Example:
    // List<FileMetadata> findByUserId(Integer userId);

    // List<FileMetadata> findByFileType(String fileType);

    // Additional custom methods to support your analytics could be added here
    // such as methods to find files by size range, date range, etc.
}
