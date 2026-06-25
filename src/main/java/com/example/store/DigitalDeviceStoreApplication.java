package com.example.store;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.example.store.mapper")
public class
DigitalDeviceStoreApplication {

    public static void main(String[] args) {
        SpringApplication.run(DigitalDeviceStoreApplication.class, args);
    }
}
