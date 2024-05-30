package com.train.hostitstorage.model;

import io.minio.messages.Item;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Objects;

public class FileDTO {
    private String name;
    private long size;
    private LocalDateTime lastModified;
    private String type;

    public FileDTO(Item item, String userFolder) {
        this.setName(item.objectName(), userFolder);
        this.size= item.size();
        this.setType(item.isDir());
        if (Objects.equals(this.type, "Folder") ){
            this.lastModified = null;
        } else {
            this.lastModified = item.lastModified().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name, String userFolder){
         name= name.replaceFirst(  userFolder+ "/", "");
        if (name.endsWith("/")) {
            name = name.substring(0, name.length() - 1); // Remove the last '/'
        }
        this.name = name;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public LocalDateTime getLastModified() {
        return lastModified;
    }

    public void setLastModified(ZonedDateTime lastModified) {
       if(lastModified == null){
            this.lastModified = null;
        } else{
         this.lastModified = lastModified.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        }
    }

    public String getType() {
        return type;
    }

    public void setType(boolean isDir) {
        this.type = isDir ? "Folder" : "File";;
    }
}
