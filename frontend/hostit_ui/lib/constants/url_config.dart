class UrlConfig {
  static const String baseStorageApiUrl =
    //  "https://e33aabe7f48d4cb8e843e9d53a159d02.loophole.site/api";
  // "http://192.168.129.101:8001/api";
  "http://localhost:8001/api";
  static const String baseFileStorageUrl = "$baseStorageApiUrl/storage/file";
  static const String baseFolderStorageUrl =
      "$baseStorageApiUrl/storage/folder";
  static const String baseUserUrl = "$baseStorageApiUrl/user";
  static const String baseAuthUrl =
  //    "https://878f52e7cdf27868125acbba10d1ee87.loophole.site/api/auth";
  "http://localhost:8002/api/auth";
}
