// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/ngrok_headers.dart';
import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/models/folder_content_model.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter

class FolderService {
  final String _baseUrl = UrlConfig.baseFolderStorageUrl;
  final Logger _logger = Logger();
  int userId = UserService().getUserId();

  Future<bool> createFolder(String folderPath, BuildContext context) async {
    try {
      final url =
          Uri.parse("$_baseUrl/create?userId=$userId&folderPath=$folderPath");
      final response = await http.post(url, headers: ngrokHeaders);
      if (response.statusCode == 200) {
        _logger.i("Folder created");
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

  Future<List<FolderContentModel>>? getFolderContent(String folderName) async {
    final url = Uri.parse(
        "$_baseUrl/foldercontents?userId=$userId&folderName=$folderName");
    final response = await http.get(url, headers: ngrokHeaders);
    if (response.statusCode == 200) {
      _logger.i("Data fetched");
      final List<dynamic> userFiles =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      _logger.i(userFiles);
      var mappedFiles =
          userFiles.map((file) => FolderContentModel.fromJson(file)).toList();
      _logger.i(mappedFiles);
      return mappedFiles;
    } else {
      throw Exception('Failed on fetching the list of files');
    }
  }

  Future<bool> deleteFolder(String folderPath, BuildContext context) async {
    try {
      final url =
          Uri.parse("$_baseUrl/delete?userId=$userId&folderPath=$folderPath");
      final response = await http.delete(url, headers: ngrokHeaders);
      if (response.statusCode == 200) {
        _logger.i("Folder deleted");
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
}
