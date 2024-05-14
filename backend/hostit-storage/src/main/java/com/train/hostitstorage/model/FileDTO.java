package com.train.hostitstorage.model;

import java.sql.Timestamp;

public record FileDTO(
        Integer id,
        String objectName,
        String contentType,
        String bucketName,
        long objectSize,
        Timestamp createdAt) { }
