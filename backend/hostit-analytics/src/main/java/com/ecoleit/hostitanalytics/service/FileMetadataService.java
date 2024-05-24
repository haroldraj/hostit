package com.ecoleit.hostitanalytics.service;

import com.ecoleit.hostitanalytics.entitie.FileMetadata;
import java.io.Writer;
import java.util.List;

public interface FileMetadataService {

    /**
     * Find all file metadata entries.
     * @return a list of all file metadata.
     */
    List<FileMetadata> findAll();

    /**
     * Write all file metadata to a CSV format.
     * @param writer the writer to write the CSV data to.
     */
    void writeMetadataToCsv(Writer writer);

    /**
     * Save file metadata to the database.
     * @param fileMetadata the file metadata to save.
     * @return the saved file metadata.
     */
    FileMetadata save(FileMetadata fileMetadata);

    /**
     * Find file metadata by ID.
     * @param id the ID of the file metadata to find.
     * @return the found file metadata, or null if none found.
     */
    FileMetadata findById(Long id);

    /**
     * Delete file metadata by ID.
     * @param id the ID of the file metadata to delete.
     */
    void deleteById(Long id);
}
