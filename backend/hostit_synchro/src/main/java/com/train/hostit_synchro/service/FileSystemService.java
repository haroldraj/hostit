package com.train.hostit_synchro.service;

import java.io.File;
import java.util.List;

public interface FileSystemService {

    List<File> listFiles(String directoryPath);

    void createDirectory(String directoryPath);

    void deleteFile(String filePath);

    void moveFile(String sourceFilePath, String destinationFilePath);

   // void watchDirectory(String directoryPath, DirectoryChangeListener listener);
}
