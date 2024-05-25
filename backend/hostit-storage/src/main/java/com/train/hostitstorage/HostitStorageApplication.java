package com.train.hostitstorage;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication
public class HostitStorageApplication {
	public static void main(String[] args) {
		SpringApplication.run(HostitStorageApplication.class, args);
	}
}
