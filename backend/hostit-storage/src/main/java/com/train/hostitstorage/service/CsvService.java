package com.train.hostitstorage.service;

import com.train.hostitstorage.entity.FileMetadata;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@Service
public class CsvService {

    public ByteArrayInputStream filesToCSV(List<FileMetadata> files) throws IOException {
        final CSVFormat format = CSVFormat.DEFAULT.withHeader("ID", "Name", "Content Type", "Size", "Upload Date", "Path", "User ID");
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        CSVPrinter csvPrinter = new CSVPrinter(new PrintWriter(out), format);

        for (FileMetadata file : files) {
            csvPrinter.printRecord(file.getId(), file.getName(), file.getContentType(), file.getSize(), file.getUploadDate(), file.getPath(), file.getUserId());
        }

        csvPrinter.flush();
        return new ByteArrayInputStream(out.toByteArray());
    }
}
