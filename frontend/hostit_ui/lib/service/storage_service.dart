import 'package:hostit_ui/constants/url_config.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';

class StorageService {
  final String _baseUrl = UrlConfig.baseStorageUrl;
  final Logger _logger = Logger();

  Future uploadBytes(
      List<int> bytes, String filename, String contenType) async {
    final String fileUploadUrl = "$_baseUrl/upload";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(fileUploadUrl));
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: MediaType(
              contenType.split('/').first, contenType.split('/').last),
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
}
