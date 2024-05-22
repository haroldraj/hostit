import 'package:intl/intl.dart';

class FileModel {
  final String? name;
  final String? contentType;
  final int? size;
  final DateTime? uploadDate;
  final List<int>? bytes;
  final String? path;
  final int? userId;

  const FileModel({
    this.path,
    this.name,
    this.contentType,
    this.size,
    this.uploadDate,
    this.bytes,
    this.userId,
  });

  String get sizeToString {
    final kb = size! / 1024;
    final mb = kb / 1024;

    return mb > 1
        ? '${mb.toStringAsFixed(2)} MiB'
        : '${kb.toStringAsFixed(2)} KiB';
  }

  String get uploadDateToString {
    return DateFormat('dd MMM yyyy • h:mma').format(uploadDate!);
  }

  factory FileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FileModel.empty();
    }

    return FileModel(
      name: json['name'] as String?,
      contentType: json['contentType'] as String?,
      size: json['size'] as int?,
      userId: json['userId'] as int?,
      path: json['path'] as String?,
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'])
          : null,
    );
  }

  FileModel.empty()
      : name = '',
        size = 0,
        contentType = '',
        uploadDate = DateTime.now(),
        bytes = [],
        path = "",
        userId = 0;
}
