import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/storage_service.dart';
import 'package:hostit_ui/widgets/custom_data_table.dart';
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
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Spacing.vertical,
                      FileListWidget(files: files),
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
        clickable: true,
        showActionsColumn: true,
        buttonName: "Download",
        columns: Responsive.isMobile(context)
            ? const ["Name"]
            : Responsive.isTablet(context)
                ? const ["Name", "Size", "Date"]
                : const ["Name", "Type", "Size", "Date"],
        data: files
                ?.map((file) => Responsive.isMobile(context)
                    ? [file.name]
                    : Responsive.isTablet(context)
                        ? [
                            file.name,
                            file.sizeToString,
                            file.uploadDate.toString(),
                          ]
                        : [
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
