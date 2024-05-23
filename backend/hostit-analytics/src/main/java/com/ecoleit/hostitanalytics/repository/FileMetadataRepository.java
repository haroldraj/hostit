package com.ecoleit.hostitanalytics.repository;


import com.ecoleit.hostitanalytics.entitie.FileMetadata;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FileMetadataRepository extends JpaRepository<FileMetadata, Long>
{
}
