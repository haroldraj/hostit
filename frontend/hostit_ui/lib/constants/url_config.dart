class UrlConfig {
  static const String baseStorageApiUrl = "http://localhost:8001/api";
  static const String baseFileStorageUrl = "$baseStorageApiUrl/storage/file";
  static const String baseFolderStorageUrl =
      "$baseStorageApiUrl/storage/folder";
  static const String baseUserUrl = "$baseStorageApiUrl/user";
  static const String baseAuthUrl = "http://localhost:8002/api/auth";
}
