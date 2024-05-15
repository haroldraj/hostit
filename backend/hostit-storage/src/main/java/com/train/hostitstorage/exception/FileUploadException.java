package com.train.hostitstorage.exception;

public class FileUploadException extends Exception {
    private final String errorCode;

    public FileUploadException(String message, String errorCode) {
        super(message);
        this.errorCode = errorCode;
    }

    public String getErrorCode() {
        return errorCode;
    }
}
