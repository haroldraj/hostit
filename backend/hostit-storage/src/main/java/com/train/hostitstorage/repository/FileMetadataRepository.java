package com.train.hostitstorage.repository;

import com.train.hostitstorage.entity.FileMetadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long> {
    List<FileMetadata> findByUserId(Long userId);
    FileMetadata findByUserIdAndPath(Long userId, String path);
     List<FileMetadata> findDistinctByUserIdAndFolderName(Long userId, String folderName);
     void deleteByUserIdAndFolderName(Long userId, String folderName);
}
