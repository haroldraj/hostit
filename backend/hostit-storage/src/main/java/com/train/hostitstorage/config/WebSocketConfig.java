package com.train.hostitstorage.config;

import com.train.hostitstorage.handler.FileUpdateHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

//@Configuration
//@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer{

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(new FileUpdateHandler(), "/api/file-updates").setAllowedOrigins("*");
    }

  //  @Bean
    public FileUpdateHandler fileUpdateHandler() {
        return new FileUpdateHandler();
    }
}
