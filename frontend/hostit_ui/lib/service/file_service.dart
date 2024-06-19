// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/ngrok_headers.dart';
import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/providers/file_data_model_provider.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:provider/provider.dart';

class FileService {
  final String _baseUrl = UrlConfig.baseFileStorageUrl;
  final Logger _logger = Logger();
  int userId = UserService().getUserId();

  Future uploadBytes(
      FileModel fileModel, String folderName, BuildContext context) async {
    final url = "$_baseUrl/upload";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['userId'] = userId.toString();
      request.fields['filepath'] = folderName;
      request.headers['ngrok-skip-browser-warning'] =
          ngrokHeaders['ngrok-skip-browser-warning']!;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileModel.bytes!,
          filename: fileModel.name,
          contentType: MediaType(fileModel.contentType!.split('/').first,
              fileModel.contentType!.split('/').last),
        ),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        var finalResponse = await response.stream.bytesToString();
        _logger.i(finalResponse);
        var fileDataModelProvider =
            Provider.of<FileDataModelProvider>(context, listen: false);
        var folderPathProvider =
            Provider.of<FolderPathProvider>(context, listen: false);
        folderPathProvider.setFolderPath(folderPathProvider.folderPath);
        await fileDataModelProvider.fetchFiles();
      } else {
        _logger.e('Failed to upload file: ${response.reasonPhrase}');
      }
    } catch (e) {
      _logger.e('Exception while uploading file: $e');
    }
  }

  Future<List<FileModel>>? getUserFiles() async {
    final url = Uri.parse("$_baseUrl/files?userId=$userId");
    final response = await http.get(url, headers: ngrokHeaders);
    if (response.statusCode == 200) {
      _logger.i("Data fetched");
      final List<dynamic> userFiles = json
          .decode(utf8.decode(response.bodyBytes))["result"] as List<dynamic>;
      _logger.i(userFiles);
      var mappedFiles =
          userFiles.map((file) => FileModel.fromJson(file)).toList();
      _logger.i(mappedFiles);
      return mappedFiles;
    } else {
      throw Exception('Failed on fetching the list of files');
    }
  }

  Future<bool> deleteFile(String filePath, BuildContext context) async {
    try {
      final url =
          Uri.parse("$_baseUrl/delete?userId=$userId&filePath=$filePath");
      final response = await http.delete(url, headers: ngrokHeaders);
      if (response.statusCode == 200) {
        _logger.i("File deleted");
        var folderPathProvider =
            Provider.of<FolderPathProvider>(context, listen: false);
        folderPathProvider.setFolderPath(folderPathProvider.folderPath);
        return true;
      } else {
        return false;
        //throw Exception('Failed to delete the file');
      }
    } catch (e) {
      return false;
      //throw Exception('Failed to delete the file');
      //_logger.e('Exception while deleting file: $e');
    }
  }

  Future getFileDownloadUri(String filePath) async {
    final url =
        Uri.parse("$_baseUrl/uridownload?&userId=$userId&filePath=$filePath");
    final response = await http.get(url, headers: ngrokHeaders);
    if (response.statusCode == 200) {
      _logger.i("Data fetched");
      final String fileDownloadUri =
          json.decode(utf8.decode(response.bodyBytes))["downloadUri"] as String;
      _logger.i(fileDownloadUri);
      if (fileDownloadUri.isEmpty) {
        _logger.e("File does'nt exist");
      }
      return fileDownloadUri;
    } else {
      throw Exception('Failed on fetching the list of files');
    }
  }

  Future downloadFile(String filePath) async {
    debugPrint('Download file: $filePath');
    try {
      final url =
          // Uri.parse("$_baseUrl/download?&userId=$userId&filePath=$filePath");
          Uri.parse(await getFileDownloadUri(filePath));
      _logger.i("url : $url");

      var response = await http.get(url);
      final blob = html.Blob([response.bodyBytes]);
      final anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob).toString(),
      )..setAttribute('download', filePath);
      html.document.body!.children.add(anchorElement);
      anchorElement.click();
      html.document.body!.children.remove(anchorElement);
      _logger.i("Trying to write ");
    } catch (e) {
      _logger.e(e);
      throw Exception(e);
    }
  }

  Future openFile(String filePath) async {
    html.AnchorElement(
      href: await getFileDownloadUri(filePath),
    )
      ..target = 'blank'
      ..click();
    debugPrint('Open file in new Tab: $filePath');
  }
}
