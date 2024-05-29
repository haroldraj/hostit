import 'package:hostit_ui/constants/url_config.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
// ignore: avoid_web_libraries_in_flutter

class FolderService {
  final String _baseUrl = UrlConfig.baseFolderStorageUrl;
  final Logger _logger = Logger();

  Future<bool> createFolder(int userId, String folderPath) async {
    try {
      final url =
          Uri.parse("$_baseUrl/create?userId=$userId&folderPath=$folderPath");
      final response = await http.post(url);
      if (response.statusCode == 200) {
        _logger.i("Folder created");
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
