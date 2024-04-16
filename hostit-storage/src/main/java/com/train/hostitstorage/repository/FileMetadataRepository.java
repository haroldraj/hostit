package com.train.hostitstorage.repository;

import com.train.hostitstorage.model.FileMetadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long> {
    // You can define custom query methods if needed
}
