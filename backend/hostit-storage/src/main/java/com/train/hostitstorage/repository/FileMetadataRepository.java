package com.train.hostitstorage.repository;

import com.train.hostitstorage.entity.FileMetadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long> {
    boolean existsByName(String name);
    List<FileMetadata> findByFolderName(String folderName);
}
