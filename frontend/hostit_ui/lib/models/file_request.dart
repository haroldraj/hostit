import 'package:hostit_ui/models/file_model.dart';

class FileRequest {
  final String? folderName;
  final List<FileModel>? result;

  FileRequest({
    required this.folderName,
    required this.result,
  });

  factory FileRequest.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FileRequest.empty();
    }
    return FileRequest(
      folderName: json['buckeName'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((file) => FileModel.fromJson(file as Map<String, dynamic>))
          .toList(),
    );
  }

  FileRequest.empty()
      : folderName = "",
        result = [];
}
