package com.train.hostitstorage;

import io.minio.MinioClient;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HostitStorageApplication {

	public static void main(String[] args) {
		SpringApplication.run(HostitStorageApplication.class, args);
	}
}
