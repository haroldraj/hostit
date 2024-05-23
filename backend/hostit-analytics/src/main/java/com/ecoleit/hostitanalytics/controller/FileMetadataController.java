package com.ecoleit.hostitanalytics.controller;

// Importation des classes nécessaires
import com.ecoleit.hostitanalytics.entitie.FileMetadata;
import com.ecoleit.hostitanalytics.service.FileMetadataService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController  // Annotation pour indiquer que cette classe est un contrôleur REST
@RequestMapping("api/data")  // Définit la racine de l'URL pour les requêtes traitées par ce contrôleur
public class FileMetadataController {

    // Déclaration d'une variable de type FileMetadataService pour accéder aux services
    private final FileMetadataService fileMetadataService;

    // Constructeur pour injecter l'instance de FileMetadataService
    public FileMetadataController(FileMetadataService fileMetadataService) {
        this.fileMetadataService = fileMetadataService;
    }

    // Endpoint pour obtenir toutes les métadonnées de fichiers
    @GetMapping("")  // Associe cette méthode aux requêtes GET sur "api/data"
    public List<FileMetadata> getAllFileMetadata() {
        // Appel du service pour récupérer toutes les métadonnées de fichiers
        return fileMetadataService.getAllFileMetadata();
    }

    // Endpoint pour exporter les données des métadonnées au format CSV
    @GetMapping("/export")  // Associe cette méthode aux requêtes GET sur "api/data/export"
    public String exportDataToCSV(@RequestParam String filePath) {
        // Appel du service pour exporter les métadonnées dans un fichier CSV à l'emplacement spécifié
        fileMetadataService.exportMetadataToCSV(filePath);
        // Retourne un message de succès
        return "Les données ont été exportées avec succès au format CSV!";
    }
}
