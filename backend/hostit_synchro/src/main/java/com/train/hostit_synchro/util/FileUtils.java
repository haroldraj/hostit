package com.train.hostit_synchro.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class FileUtils {

    public static void copyFile(File sourceFile, File destinationFile) throws IOException {
        Files.copy(sourceFile.toPath(), destinationFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
    }

    public static void moveFile(File sourceFile, File destinationFile) throws IOException {
        Files.move(sourceFile.toPath(), destinationFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
    }

    public static void deleteFile(File file) throws IOException {
        Files.deleteIfExists(file.toPath());
    }

    public static void createDirectory(String directoryPath) throws IOException {
        Files.createDirectories(Path.of(directoryPath));
    }
}
