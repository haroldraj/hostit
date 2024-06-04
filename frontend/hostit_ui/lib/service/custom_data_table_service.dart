// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/providers/file_data_model_provider.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/service/file_service.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class CustomDataTableService {
  final FileService _fileService = FileService();
  final FolderService _folderService = FolderService();

  Future<void> handleDownloadFile(String filePath) async {
    await _fileService.downloadFile(filePath);
  }

  Future<void> handleDeleteFile(String filePath, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          "Confirmation",
          style: TextStyle(color: CustomColors.redColor),
        ),
        content: Text("Do you really want to delete the file $filePath ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () async {
              bool isDeleted = await _fileService.deleteFile(filePath, context);
              if (isDeleted) {
                var fileDataModelProvider =
                    Provider.of<FileDataModelProvider>(context, listen: false);
                fileDataModelProvider.fetchFiles();

                Navigator.pop(context);
              }
            },
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  Future<void> handleDownloadFolder(
      String folderPath, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            Spacing.horizontal,
            Text(
              "Info",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        content: const Text("You'll be able to download folders soon."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          /* TextButton(
            onPressed: () async {
              bool isDeleted = await _fileService.deleteFile(folderPath);
              if (isDeleted) {
                var fileDataModelProvider =
                    // ignore: use_build_context_synchronously
                    Provider.of<FileDataModelProvider>(context, listen: false);
                fileDataModelProvider.fetchFiles();
                _close();
              }
            },
            child: const Text("YES"),
          ),*/
        ],
      ),
    );
  }

  Future<void> handleDeleteFolder(
      String folderPath, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          "Confirmation",
          style: TextStyle(color: CustomColors.redColor),
        ),
        content: Text(
            "Do you really want to delete the folder $folderPath with its content?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () async {
              bool isDeleted = await _folderService.deleteFolder(folderPath, context);
              if (isDeleted) {
                var fileDataModelProvider =
                    Provider.of<FileDataModelProvider>(context, listen: false);
                fileDataModelProvider.fetchFiles();
                Navigator.pop(context);
              }
            },
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  Future<void> handleOpenFile(
      String filePath, String fileOrFolderName, BuildContext context) async {
    bool isAFolder = path.extension(fileOrFolderName).isEmpty;

    if (isAFolder) {
      var folderPathProvider =
          Provider.of<FolderPathProvider>(context, listen: false);

      folderPathProvider.addFolderPath(fileOrFolderName);
    } else {
      await _fileService.openFile(filePath);
    }
  }
}
