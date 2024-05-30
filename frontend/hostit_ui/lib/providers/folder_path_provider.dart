import 'package:flutter/material.dart';

class FolderPathProvider extends ChangeNotifier {
  List<String> _folderPath = ["My Hostit"];
  String _searchQuery = "";
  List<String> get folderPath => _folderPath;

  String get folderPathToString {
    if (_folderPath.length > 2) {
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
    _folderPath.add(folder);
    notifyListeners();
  }

  void removeFolderPath() {
    if (_folderPath.isNotEmpty) {
      _folderPath.removeLast();
      notifyListeners();
    }
  }
}
