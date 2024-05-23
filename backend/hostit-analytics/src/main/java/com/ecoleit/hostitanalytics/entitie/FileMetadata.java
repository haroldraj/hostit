package com.ecoleit.hostitanalytics.entitie;

// Importation des classes nécessaires pour la gestion de la persistance et des entités
import jakarta.persistence.*;

import java.sql.Timestamp;

// Annotation pour indiquer que cette classe est une entité JPA
@Entity
// Annotation pour spécifier le nom de la table dans la base de données
@Table(name = "file_metadata")
public class FileMetadata {
    // Annotation pour indiquer que ce champ est la clé primaire
    @Id
    private Long Id;

    // Champ pour stocker l'identifiant de l'utilisateur
    private String userId;

    // Champ pour stocker le nom
    private String Name;

    // Champ pour stocker le type de contenu
    private String contentType;

    // Champ pour stocker la date de téléchargement
    private Timestamp uploadDate;

    // Champ pour stocker la taille du fichier
    private String size;

    // Champ pour stocker le nom du fichier
    private String filename;

    // Getter pour le champ userId
    public String getUserId() {
        return userId;
    }

    // Setter pour le champ userId
    public void setUserId(String userId) {
        this.userId = userId;
    }

    // Getter pour le champ Id
    public Long getId() {
        return Id;
    }

    // Setter pour le champ Id
    public void setId(Long id) {
        Id = id;
    }

    // Getter pour le champ Name
    public String getName() {
        return Name;
    }

    // Setter pour le champ Name
    public void setName(String name) {
        Name = name;
    }

    // Getter pour le champ contentType
    public String getContentType() {
        return contentType;
    }

    // Setter pour le champ contentType
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    // Getter pour le champ uploadDate
    public Timestamp getUploadDate() {
        return uploadDate;
    }

    // Setter pour le champ uploadDate
    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    // Getter pour le champ size
    public String getSize() {
        return size;
    }

    // Setter pour le champ size
    public void setSize(String size) {
        this.size = size;
    }

    // Getter pour le champ filename
    public String getFilename() {
        return filename;
    }

    // Setter pour le champ filename
    public void setFilename(String filename) {
        this.filename = filename;
    }
}
