package com.train.hostitstorage.model;

public record FileUploadDTO(
        String bucketName,
        String objectName,
        String contentType,
        String fileName,
        long objectSize
) {
}
