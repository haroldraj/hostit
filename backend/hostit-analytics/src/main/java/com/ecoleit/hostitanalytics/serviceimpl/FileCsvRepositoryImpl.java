package com.ecoleit.hostitanalytics.serviceimpl;

// Importation des classes nécessaires
import com.ecoleit.hostitanalytics.entitie.FileMetadata;
import com.ecoleit.hostitanalytics.repository.FileCsvRepository;
import com.opencsv.CSVWriter;
import org.springframework.stereotype.Service;

import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

@Service  // Annotation pour indiquer que cette classe est un service Spring
public class FileCsvRepositoryImpl implements FileCsvRepository {

    @Override  // Annotation pour indiquer que cette méthode implémente une méthode définie dans l'interface FileCsvRepository
    public void writeDataToCSV(String filePath, List<FileMetadata> data) {
        // Utilisation de try-with-resources pour assurer la fermeture du CSVWriter
        try (CSVWriter writer = new CSVWriter(new FileWriter(filePath))) {
            // Écrire l'en-tête du fichier CSV
            String[] header = { "Id", "UserId", "Name", "ContentType", "UploadDate", "Size", "Filename" };
            writer.writeNext(header);

            // Écrire les données pour chaque FileMetadata dans la liste
            for (FileMetadata file : data) {
                // Créer une ligne de données à partir des propriétés de FileMetadata
                String[] line = {
                        String.valueOf(file.getId()),  // Conversion de l'Id en chaîne
                        file.getUserId(),  // Obtention de l'UserId
                        file.getName(),  // Obtention du Name
                        file.getContentType(),  // Obtention du ContentType
                        String.valueOf(file.getUploadDate()),  // Conversion de l'UploadDate en chaîne
                        file.getSize(),  // Obtention de la Size
                        file.getFilename()  // Obtention du Filename
                };
                // Écrire la ligne de données dans le fichier CSV
                writer.writeNext(line);
            }
        } catch (IOException e) {
            // Gestion de l'exception en cas d'erreur d'entrée/sortie
            e.printStackTrace();
        }
    }
}
