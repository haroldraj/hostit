package com.train.hostitstorage.repository;

import com.train.hostitstorage.entity.FileMetadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long> {
    List<FileMetadata> findByUserId(Long userId);
    FileMetadata findByUserIdAndPath(Long userId, String path);
     List<FileMetadata> findDistinctByUserIdAndFolderName(Long userId, String folderName);

     @Modifying
     @Query("DELETE FROM FileMetadata fm WHERE fm.userId = :userId AND fm.folderName LIKE :folderName%")
     void deleteByUserIdAndFolderNameStartingWith(Long userId, String folderName);
}
