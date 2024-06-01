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
}
