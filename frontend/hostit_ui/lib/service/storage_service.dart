import 'package:hostit_ui/constants/url_config.dart';
import 'package:hostit_ui/models/dropped_file.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class StorageService {
  final String _baseUrl = UrlConfig.baseStorageUrl;

  void uploadFile(DroppedFile droppedFile) {
    // Convertir le blob en fichier
    //final response = await http.get(Uri.parse(droppedFile.url));
    //final directory = await getApplicationDocumentsDirectory();
    //final file = File('${directory.path}/${droppedFile.name}');
    //await file.writeAsBytes(response.bodyBytes);
    
    print(droppedFile.url);
    // Envoyer le fichier au serveur
    //final request =
    //   http.MultipartRequest('POST', Uri.parse('$_baseUrl/files/upload'));
    //request.files.add(await http.MultipartFile.fromPath('file', file.path));
    //final res = await request.send();

    //if (res.statusCode == 200) {
    //print('Upload successful');
    //} else {
    //print('Upload failed');
    //}
  }
}
