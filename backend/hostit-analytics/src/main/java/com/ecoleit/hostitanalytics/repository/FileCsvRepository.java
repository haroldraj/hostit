package com.ecoleit.hostitanalytics.repository;

import com.ecoleit.hostitanalytics.entitie.FileMetadata;

import java.util.List;

public interface FileCsvRepository {
    void writeDataToCSV(String filePath, List<FileMetadata> data);
}
