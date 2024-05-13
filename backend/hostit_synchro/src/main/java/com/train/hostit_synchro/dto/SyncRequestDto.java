package com.train.hostit_synchro.dto;

public class SyncRequestDto {

    private String sourcePath;
    private String targetPath;
    private boolean recursiveSync;

    // Default constructor for deserialization
    public SyncRequestDto() {
    }

    // Parametrized constructor for creating instances with values
    public SyncRequestDto(String sourcePath, String targetPath, boolean recursiveSync) {
        this.sourcePath = sourcePath;
        this.targetPath = targetPath;
        this.recursiveSync = recursiveSync;
    }

    // Getters and setters
    public String getSourcePath() {
        return sourcePath;
    }

    public void setSourcePath(String sourcePath) {
        this.sourcePath = sourcePath;
    }

    public String getTargetPath() {
        return targetPath;
    }

    public void setTargetPath(String targetPath) {
        this.targetPath = targetPath;
    }

    public boolean isRecursiveSync() {
        return recursiveSync;
    }

    public void setRecursiveSync(boolean recursiveSync) {
        this.recursiveSync = recursiveSync;
    }

    // Overriding toString() can be useful for logging or debugging
    @Override
    public String toString() {
        return "SyncRequestDto{" +
                "sourcePath='" + sourcePath + '\'' +
                ", targetPath='" + targetPath + '\'' +
                ", recursiveSync=" + recursiveSync +
                '}';
    }
}
