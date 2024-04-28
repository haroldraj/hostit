package com.train.hostit_synchro.repository;

import com.train.hostit_synchro.model.SyncJob;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SyncJobRepository extends JpaRepository
{
    SyncJob findBySourcePath(String sourcePath);

    SyncJob findByTargetPath(String targetPath);

    SyncJob findBySourcePathAndTargetPath(String sourcePath, String targetPath);

    SyncJob findBySourcePathAndTargetPathAndRecursive(String sourcePath, String targetPath, boolean recursive);

    SyncJob findBySourcePathAndTargetPathAndRecursiveAndStatus(String sourcePath, String targetPath, boolean recursive, String status);

    SyncJob findBySourcePathAndTargetPathAndStatus(String sourcePath, String targetPath, String status);

    SyncJob findBySourcePathAndRecursive(String sourcePath, boolean recursive);

    SyncJob findByTargetPathAndRecursive(String targetPath, boolean recursive);
}