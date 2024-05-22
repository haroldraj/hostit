package com.train.hostitstorage.repository;

import com.train.hostitstorage.entity.FileMetadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long> {
    boolean existsByName(String name);
    List<FileMetadata> findByPath(String folderName);
    List<FileMetadata> findByUserId(Long userId);
    FileMetadata findByUserIdAndPath(Long userId, String path);
     //Optional deleteByUserIdAndPath(Long userId, String path);
}
