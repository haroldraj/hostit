package com.train.hostitstorage.handler;
import org.hibernate.annotations.Comment;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.socket.CloseStatus;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class FileUpdateHandler extends TextWebSocketHandler{
    /*private List<WebSocketSession> sessions = new ArrayList<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
    }

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        for(WebSocketSession webSocketSession : sessions){
            try{
                webSocketSession.sendMessage(message);
            }catch(IOException e){
                e.printStackTrace();
            }
        }
    }

    public void broadcastUpdate(String updateMessage) {
        for (WebSocketSession session : sessions) {
            try {
                session.sendMessage(new TextMessage(updateMessage));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }*/
    private final List<WebSocketSession> sessions = new ArrayList<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
    }

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        for (WebSocketSession webSocketSession : sessions) {
            if (webSocketSession.isOpen()) {
                webSocketSession.sendMessage(message);
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
    }

    public void sendMessageToAll(String message) throws IOException {
        for (WebSocketSession session : sessions) {
            if (session.isOpen()) {
                session.sendMessage(new TextMessage(message));
            }
        }
    }
}
