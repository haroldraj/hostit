import 'package:flutter/material.dart';

class FolderPathProvider extends ChangeNotifier {
  List<String> _folderPath = ["My Hostit"];
  String _searchQuery = "";
  List<String> get folderPath => _folderPath;

  String get folderPathToString {
    if (_folderPath.length > 1) {
      return _folderPath.join('/');
    } else {
      return _folderPath.join();
    }
  }

  String get searchQuery => _searchQuery;

  void setFolderPath(List<String> newPath) {
    _folderPath = newPath;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addFolderPath(String folder) {
    List<String> parts = folder.split('/');
    _folderPath.add(parts.last);
    notifyListeners();
  }

  void removeFolderPath() {
    if (_folderPath.isNotEmpty) {
      _folderPath.removeLast();
      notifyListeners();
    }
  }
}
