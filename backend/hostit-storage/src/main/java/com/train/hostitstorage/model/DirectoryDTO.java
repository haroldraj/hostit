package com.train.hostitstorage.model;

public class DirectoryDTO {
    private String name; // The directory name or prefix
    private String bucketName; // The bucket where this "directory" is located

    // Constructor
    public DirectoryDTO(String name, String bucketName) {
        this.name = name;
        this.bucketName = bucketName;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBucketName() {
        return bucketName;
    }

    public void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    @Override
    public String toString() {
        return "DirectoryDTO{" +
                "name='" + name + '\'' +
                ", bucketName='" + bucketName + '\'' +
                '}';
    }
}
