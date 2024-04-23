package com.train.hostit_synchro.service;

import java.io.File;

public interface CloudStorageService {

    void uploadFile(File file);

    void downloadFile(String fileName);

    void deleteFile(String fileName);

    boolean fileExists(String fileName);
}

