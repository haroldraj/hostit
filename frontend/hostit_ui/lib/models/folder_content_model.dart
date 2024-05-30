import 'package:intl/intl.dart';

class FolderContentModel {
  final String? name;
  final int? size;
  final DateTime? lastModified;
  final String? type;

  const FolderContentModel({
    this.name,
    this.size,
    this.lastModified,
    this.type,
  });

  String get sizeToString {
    final kb = size! / 1024;
    final mb = kb / 1024;
    final gb = mb / 1024;

    if (size == 0) {
      return '-';
    }

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

  String get lastModifiedToString {
    if (lastModified == null) {
      return '-';
    }
    return DateFormat('dd MMM yyyy').format(lastModified!);
  }

  factory FolderContentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FolderContentModel.empty();
    }
    return FolderContentModel(
      name: json['name'] as String?,
      type: json['type'] as String?,
      size: json['size'] as int?,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'])
          : null,
    );
  }

  FolderContentModel.empty()
      : name = '',
        size = null,
        lastModified = null,
        type = "";
}
