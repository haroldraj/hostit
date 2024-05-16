import 'dart:convert';

import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';

class StorageService {
  final String _baseUrl = UrlConfig.baseStorageUrl;
  final Logger _logger = Logger();

  Future uploadBytes(FileModel fileModel) async {
    final url = "$_baseUrl/upload";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['userId'] = '1';
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

  Future<List<FileModel>>? getUserFiles(String userId) async {
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

  Future getFileDownloadUri(String userId, String fileName) async {
    final url =
        Uri.parse("$_baseUrl/download?userId=$userId&fileName=$fileName");
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
}
