package com.train.hostitstorage.repository;

import com.train.hostitstorage.entity.File;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FileRepository extends JpaRepository<File, Integer>{
    List<File> findByBucketName(String bucketName);
    Optional<File> findByObjectName(String objectName);
}
