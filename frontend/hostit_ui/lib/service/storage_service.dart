import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';

class StorageService {
  final String _baseUrl = UrlConfig.baseStorageUrl;
  final Logger _logger = Logger();

  Future uploadBytes(FileModel fileModel) async {
    final String fileUploadUrl = "$_baseUrl/upload";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(fileUploadUrl));
      request.fields['userId'] = '1';
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileModel.bytes!,
          filename: fileModel.name,
          contentType: MediaType(fileModel.mime!.split('/').first,
              fileModel.mime!.split('/').last),
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
