import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hostit_ui/constants/ngrok_headers.dart';
import 'package:hostit_ui/constants/url_config.dart';
import 'package:http/http.dart' as http;
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:logger/logger.dart';

class FileDataModelProvider extends ChangeNotifier {
  List<FileModel> _files = [];
  final String _baseUrl = UrlConfig.baseFileStorageUrl;
  final Logger _logger = Logger();
  List<FileModel> get files => _files;

  Future<List<FileModel>>? getUserFiles() async {
    int userId = UserService().getUserId();
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

  Future<void> fetchFiles() async {
    int userId = UserService().getUserId();
    final url = Uri.parse("$_baseUrl/files?userId=$userId");
    final response = await http.get(url, headers: ngrokHeaders);
    if (response.statusCode == 200) {
      _logger.i("Data fetched");
      _files = List<FileModel>.from(json
          .decode(utf8.decode(response.bodyBytes))["result"]
          .map((data) => FileModel.fromJson(data)));
      notifyListeners();
    } else {
      throw Exception('Failed to load files');
    }
  }

  /* Future<void> addFile(FileModel file) async {
    final response = await http.post(
      Uri.parse('https://your-backend-url.com/files'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(file.toJson()),
    );
    if (response.statusCode == 201) {
      fetchFiles();
    } else {
      throw Exception('Failed to add file');
    }
  }

  Future<void> deleteFile(int fileId) async {
    final response = await http.delete(
      Uri.parse('https://your-backend-url.com/files/$fileId'),
    );
    if (response.statusCode == 200) {
      fetchFiles();
    } else {
      throw Exception('Failed to delete file');
    }
  }*/
}
