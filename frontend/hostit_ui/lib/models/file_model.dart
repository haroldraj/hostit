import 'package:intl/intl.dart';

class FileModel {
  final String? name;
  final String? contentType;
  final int? size;
  final DateTime? uploadDate;
  final List<int>? bytes;
  final String? path;
  final int? userId;
  final String? folderName;

  const FileModel({
    this.path,
    this.name,
    this.contentType,
    this.size,
    this.uploadDate,
    this.bytes,
    this.userId,
    this.folderName,
  });

  String get sizeToString {
    final kb = size! / 1024;
    final mb = kb / 1024;
    final gb = mb / 1024;

    if (size! < 1024) {
      return '${size!.toStringAsFixed(2)} B';
    } else if (kb < 1024) {
      return '${kb.toStringAsFixed(2)} KiB';
    } else if (mb < 1024) {
      return '${mb.toStringAsFixed(2)} MiB';
    } else {
      return '${gb.toStringAsFixed(2)} GiB';
    }
  }

  String get uploadDateToString {
    return DateFormat('dd MMM yyyy').format(uploadDate!);
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
      folderName: json['folderName'] as String?,
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'])
          : null,
    );
  }

  FileModel.empty()
      : name = '',
        size = 0,
        contentType = '',
        uploadDate = null,
        bytes = [],
        path = "",
        folderName = "",
        userId = 0;
}
