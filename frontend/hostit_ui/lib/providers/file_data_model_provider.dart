import 'package:flutter/foundation.dart';
import 'package:hostit_ui/service/file_service.dart';
import 'package:hostit_ui/models/file_model.dart';

class FileDataModelProvider extends ChangeNotifier {
  List<FileModel> _files = [];
  List<FileModel> get files => _files;
  bool? isLoading;

  Future<void> fetchFiles() async {
    try {
      isLoading = true;
      notifyListeners();
      _files = await FileService().getUserFiles()!;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load files: $e');
    }
  }
}
