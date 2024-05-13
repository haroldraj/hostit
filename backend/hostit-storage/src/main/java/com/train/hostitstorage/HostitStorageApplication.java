package com.train.hostitstorage;

import io.minio.MinioClient;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HostitStorageApplication {

	public static void main(String[] args) {
		//SpringApplication.run(HostitStorageApplication.class, args);
		MinioClient minioClient = MinioClient.builder()
				.endpoint("https://play.min.io")
				.credentials("B7CvxeruN5dwA9oGJEGr", "dOzJqkAh80L6veSwog1jKUqm79tWcN152qBoB5Ez")
				.build();
	}


}
