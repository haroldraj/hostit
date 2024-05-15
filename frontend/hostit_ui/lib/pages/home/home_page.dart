import 'package:flutter/material.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/service/storage_service.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storageService = StorageService();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: FutureBuilder<List<FileModel>>(
            future: _storageService.getUserFiles('1'),
            builder: (context, snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                        customCircularProgressIndicator("Loading file list..."),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  var files = snapshot.data;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("name: ${files![0].name}"),
                        Text("contentType: ${files[0].contentType!}"),
                        Text("size: ${files[0].sizeToString}"),
                        Text("uploadDate: ${files[0].uploadDate}"),
                        Text("folderName: ${files[0].folderName}"),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text("No files found"));
                }
              } on Exception catch (error) {
                return Center(
                  child: Text("Error: $error"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
