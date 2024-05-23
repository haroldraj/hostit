package com.ecoleit.hostitanalytics.service;

// Importation des classes nécessaires
import com.ecoleit.hostitanalytics.entitie.FileMetadata;
import com.ecoleit.hostitanalytics.repository.FileCsvRepository;
import com.ecoleit.hostitanalytics.repository.FileMetadataRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service  // Annotation pour indiquer que cette classe est un service Spring
public class FileMetadataService {
    // Déclaration d'une variable de type FileMetadataRepository pour accéder aux opérations sur les métadonnées des fichiers
    private final FileMetadataRepository fileMetadataRepository;

    // Déclaration d'une variable de type FileCsvRepository pour gérer l'exportation des données en CSV
    private final FileCsvRepository fileCsvService;

    // Constructeur pour injecter les instances de FileMetadataRepository et FileCsvRepository
    public FileMetadataService(FileMetadataRepository fileMetadataRepository, FileCsvRepository fileCsvService) {
        this.fileMetadataRepository = fileMetadataRepository;
        this.fileCsvService = fileCsvService;
    }

    // Méthode pour obtenir toutes les métadonnées de fichiers
    public List<FileMetadata> getAllFileMetadata() {
        // Appel du référentiel pour récupérer toutes les métadonnées de fichiers
        return fileMetadataRepository.findAll();
    }

    // Méthode pour exporter les métadonnées des fichiers au format CSV
    public void exportMetadataToCSV(String filePath) {
        // Récupération de toutes les métadonnées de fichiers
        List<FileMetadata> fileMetadataList = getAllFileMetadata();
        // Appel du service pour écrire les données dans un fichier CSV à l'emplacement spécifié
        fileCsvService.writeDataToCSV(filePath, fileMetadataList);
    }
}
