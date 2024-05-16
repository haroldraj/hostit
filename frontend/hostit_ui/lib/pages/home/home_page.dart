import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/service/storage_service.dart';
import 'package:hostit_ui/widgets/custom_data_table.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
                  return Column(
                    children: [
                      Spacing.vertical,
                      TextButton(
                          onPressed: () async {
                            String userId = '1'; // replace with actual user id
                            String fileName = files![3]
                                .name!; // replace with actual file name
                            String downloadUri = await _storageService
                                .getFileDownloadUri(userId, fileName);
                            //html.window.open(downloadUri, "Download");
                            /*final url = Uri.parse(downloadUri);
                            final response = await http.get(url);
                            final blob = html.Blob([response.bodyBytes]);
                            final anchorElement = html.AnchorElement(
                              href: html.Url.createObjectUrlFromBlob(blob)
                                  .toString(),
                            )..setAttribute('download', fileName);
                            html.document.body!.children.add(anchorElement);
                            anchorElement.click();
                            html.document.body!.children.remove(anchorElement);
                            print(response.bodyBytes.length);*/

                            // Create a new anchor element
                            html.AnchorElement(
                              href: downloadUri,
                            )
                              ..target = 'blank' // to open a new tab/window
                              //..download = fileName // to force download
                              ..click();
                          },
                          child: const Text("Download File")),
                      Spacing.vertical,
                      FileListWidget(files: files),
                    ],
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

class FileListWidget extends StatelessWidget {
  final List<FileModel>? files;
  const FileListWidget({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CustomDataTable(
        fullScreen: true,
        clickable: false,
        showActionsColumn: true,
        buttonName: "Download",
        columns: const ["Name", "Type", "Size", "Date"],
        data: files
                ?.map((file) => [
                      file.name,
                      file.contentType,
                      file.sizeToString,
                      file.uploadDate.toString(),
                    ])
                .toList() ??
            [],
        context: context,
      ),
    );
  }
}
