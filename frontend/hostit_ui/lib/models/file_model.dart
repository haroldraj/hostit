class FileModel {
  final String? name;
  final String? mime;
  final int? size;
  final DateTime? uploadDate;
  final List<int>? bytes;

  const FileModel({
    this.name,
    this.mime,
    this.size,
    this.uploadDate,
    this.bytes,
  });

  String get sizeToString {
    final kb = size! / 1024;
    final mb = kb / 1024;

    return mb > 1
        ? '${mb.toStringAsFixed(2)} MiB'
        : '${kb.toStringAsFixed(2)} KiB';
  }

  factory FileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FileModel.empty();
    }

    return FileModel(
      name: json['fileName'] as String?,
      mime: json['contentType'] as String?,
      size: json['fileSize'] as int?,
      uploadDate: json['uploadDate'] as DateTime?,
    );
  }

  FileModel.empty()
      : name = '',
        size = 0,
        mime = '',
        uploadDate = DateTime.now(),
        bytes = [];
}
