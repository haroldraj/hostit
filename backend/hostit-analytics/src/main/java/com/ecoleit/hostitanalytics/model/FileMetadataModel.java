package com.ecoleit.hostitanalytics.model;

// Classe de modèle pour représenter les métadonnées des fichiers
public class FileMetadataModel {
    // Champ pour stocker l'identifiant (sous forme de chaîne)
    private String Id;

    // Champ pour stocker l'identifiant de l'utilisateur
    private String userId;

    // Champ pour stocker le nom
    private String Name;

    // Champ pour stocker le type de contenu
    private String contentType;

    // Champ pour stocker la date de téléchargement (sous forme de chaîne)
    private String uploadDate;

    // Champ pour stocker la taille du fichier
    private String size;

    // Champ pour stocker le nom du fichier
    private String filename;

    // Getter pour le champ Id
    public String getId() {
        return Id;
    }

    // Setter pour le champ Id
    public void setId(String id) {
        Id = id;
    }

    // Getter pour le champ userId
    public String getUserId() {
        return userId;
    }

    // Setter pour le champ userId
    public void setUserId(String userId) {
        this.userId = userId;
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
    public String getUploadDate() {
        return uploadDate;
    }

    // Setter pour le champ uploadDate
    public void setUploadDate(String uploadDate) {
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
