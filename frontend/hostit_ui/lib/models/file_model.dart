class FileModel {
  final String? name;
  final String? contentType;
  final int? size;
  final DateTime? uploadDate;
  final List<int>? bytes;
  final String? folderName;

  const FileModel({
    this.folderName,
    this.name,
    this.contentType,
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
      name: json['name'] as String?,
      contentType: json['contentType'] as String?,
      size: json['size'] as int?,
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
        uploadDate = DateTime.now(),
        bytes = [],
        folderName = "";
}
