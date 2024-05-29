import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class FileService {
  final String _baseUrl = UrlConfig.baseFileStorageUrl;
  final Logger _logger = Logger();

  Future uploadBytes(int userId, FileModel fileModel) async {
    final url = "$_baseUrl/upload";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['userId'] = userId.toString();
      request.fields['filepath'] = '/check';
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
      } else {
        _logger.e('Failed to upload file: ${response.reasonPhrase}');
      }
    } catch (e) {
      _logger.e('Exception while uploading file: $e');
    }
  }

  Future<List<FileModel>>? getUserFiles(int userId) async {
    final url = Uri.parse("$_baseUrl/files?userId=$userId");
    final response = await http.get(url);
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

  Future<bool> deleteFile(int userId, String filePath) async {
    try {
      final url =
          Uri.parse("$_baseUrl/delete?userId=$userId&filePath=$filePath");
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _logger.i("File deleted");
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

  Future getFileDownloadUri(int userId, String filePath) async {
    final url =
        Uri.parse("$_baseUrl/download?&userId=$userId&filePath=$filePath");
    final response = await http.get(url);
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

  Future downloadFile(int userId, String filePath) async {
    debugPrint('Download file: $filePath');
    final url = Uri.parse(
      await getFileDownloadUri(userId, filePath),
    );
    final response = await http.get(url);
    final blob = html.Blob([response.bodyBytes]);
    final anchorElement = html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(blob).toString(),
    )..setAttribute('download', filePath);
    html.document.body!.children.add(anchorElement);
    anchorElement.click();
    html.document.body!.children.remove(anchorElement);
  }

  Future openFile(int userId, String filePath) async {
    html.AnchorElement(
      href: await getFileDownloadUri(userId, filePath),
    )
      ..target = 'blank'
      ..click();
    debugPrint('Open file in new Tab: $filePath');
  }
}
