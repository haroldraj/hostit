package com.train.hostitstorage.service;

import com.train.hostitstorage.entity.FileMetadata;
import com.train.hostitstorage.model.FileUploadResponse;
import com.train.hostitstorage.model.FileDownloadUri;
import com.train.hostitstorage.repository.FileMetadataRepository;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.sql.Timestamp;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;


@Service
public class FileService {

    //@Autowired
    //private FileUpdateHandler fileUpdateHandler;

    private final MinioService minioService;
    private final FolderService folderService;
    private final FileMetadataRepository fileMetadataRepository;

    public FileService(MinioService minioService, FolderService folderService, FileMetadataRepository fileMetadataRepository) {
        this.minioService = minioService;
        this.folderService = folderService;
        this.fileMetadataRepository = fileMetadataRepository;
    }

    public FileUploadResponse uploadFile(MultipartFile file, Long userId, String filepath) throws FileUploadException, ExecutionException, InterruptedException {
        FileUploadResponse response = new FileUploadResponse();
        String filePath;
        if(file.isEmpty()){
             filePath = folderService.getUserFolder(userId)  + "/" + file.getOriginalFilename();
        } else{
             filePath = folderService.getUserFolder(userId)  + "/" + filepath + "/" + file.getOriginalFilename();
        }

        if (minioService.fileExists(filePath)) {
            throw new FileUploadException("File already uploaded");
        }
        /*
        if (fileMetadataRepository.existsByName(fileName)) {
            throw new FileUploadException("File metadata already exists in the database");
        }*/
        CompletableFuture<String> fileUploadedPath = minioService.uploadFile(file, filePath);
        if (fileUploadedPath== null) {
            throw new FileUploadException("Failed to upload file");
        }
        //String downloadUri = minioService.generateDownloadUri(file.getOriginalFilename());
        response.setMessage("File uploaded successfully");
        response.setFileName(file.getOriginalFilename());
        response.setFileSize(file.getSize());
        response.setContentType(file.getContentType());


        FileMetadata fileMetadata = new FileMetadata();
        fileMetadata.setName(file.getOriginalFilename());
        fileMetadata.setSize(file.getSize());
        fileMetadata.setContentType(file.getContentType());
        fileMetadata.setUploadDate(new Timestamp(System.currentTimeMillis()));
        fileMetadata.setPath(fileUploadedPath.get());
        fileMetadata.setUserId(userId);
        fileMetadata.setFolderName(filepath);
        fileMetadataRepository.save(fileMetadata);

      /*  try {
            fileUpdateHandler.sendMessageToAll("File uploaded: " + file.getOriginalFilename());
        } catch (IOException e) {
            e.printStackTrace();
        }*/
        return response;
    }



    public boolean deleteFile(Long userId, String filePath) {
        try{
            String fileName = folderService.getUserFolder(userId) + "/" + filePath;
            boolean isFileDeleted = minioService.deleteFile(fileName);
            Long fileId = getUserId(userId, filePath);
            if (isFileDeleted) {
                fileMetadataRepository.deleteById(fileId);
            /*    try {
                    fileUpdateHandler.sendMessageToAll("File deleted: " + filePath);
                } catch (IOException e) {
                    e.printStackTrace();
                }*/
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
        return false;
    }

    public FileDownloadUri getFileDownloadUri(Long userId, String filePath) throws Exception {
        FileDownloadUri response = new FileDownloadUri();
        String userFolder = folderService.getUserFolder(userId);
        String fileName = userFolder + "/" + filePath;
        response.setDownloadUri(minioService.generateDownloadUri(fileName));
        response.setFileName(fileName);
        if(response.getDownloadUri() ==null){
            throw new Exception("File path '"+ filePath+"' doesn't exit");
        }
        return response;
    }

    public List<FileMetadata> getUserFiles(Long userId) {
        return fileMetadataRepository.findByUserId(userId);
    }

    public List<FileMetadata> getAllUserFiles() {
        return fileMetadataRepository.findAll();
    }

    public Long getUserId(Long userId, String filePath) {
        return fileMetadataRepository.findByUserIdAndPath(userId, filePath).getId();
    }

    /*@Scheduled(fixedRate = 3600000) // Run every hour
    public void regenerateDownloadUris() {
        List<FileMetadata> allFiles = fileMetadataRepository.findAll();
        for (FileMetadata file : allFiles) {
            String newUri = minioService.generateDownloadUri(file.getName()); // 1 hour expiry
            file.setDownloadUri(newUri);
            fileMetadataRepository.save(file);
        }
    }*/

}