import 'package:hostit_ui/models/file_model.dart';

class FileRequest {
  final String? bucketName;
  final List<FileModel>? result;

  FileRequest({
    required this.bucketName,
    required this.result,
  });

  factory FileRequest.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FileRequest.empty();
    }
    return FileRequest(
      bucketName: json['buckeName'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((file) => FileModel.fromJson(file as Map<String, dynamic>))
          .toList(),
    );
  }

  FileRequest.empty()
      : bucketName = "",
        result = [];
}
