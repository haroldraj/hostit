package com.ecoleit.hostitanalytics.repository;

import com.ecoleit.hostitanalytics.model.FileInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FileRepository extends JpaRepository<FileInfo, Long> {
    // Custom database queries can be defined here if needed
}
