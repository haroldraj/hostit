class UrlConfig {
  static const String baseStorageApiUrl =
      //"https://6f7c-2a02-a03f-682e-3901-55bb-1e40-ce91-35e9.ngrok-free.app/api";
      // "http://192.168.129.101:8001/api";
      "http://localhost:8001/api";
  static const String baseFileStorageUrl = "$baseStorageApiUrl/storage/file";
  static const String baseFolderStorageUrl =
      "$baseStorageApiUrl/storage/folder";
  static const String baseUserUrl = "$baseStorageApiUrl/user";
  static const String baseAuthUrl =
      // "https://a1e152503d2492b864414204ba9d4f47.loophole.site/api/auth";
      "http://localhost:8002/api/auth";
}
