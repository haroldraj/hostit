import 'package:flutter/material.dart';
import 'package:hostit_ui/models/folder_content_model.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/custom_data_table/custom_data_table.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

class FileListWidget extends StatefulWidget {
  const FileListWidget({super.key});

  @override
  State<FileListWidget> createState() => _FileListWidgetState();
}

class _FileListWidgetState extends State<FileListWidget> {
  final FolderService _folderService = FolderService();
  int userId = UserService().getUserId();

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderPathProvider>(
      builder: (context, folderPathProvider, child) {
        return FutureBuilder<List<FolderContentModel>>(
          future: _folderService.getFolderContent(
              userId, folderPathProvider.folderPathToString),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: customCircularProgressIndicator("Loading file list..."),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var files = snapshot.data!
                  .where((file) => file.name!
                      .toLowerCase()
                      .contains(folderPathProvider.searchQuery.toLowerCase()))
                  .toList();
              return CustomDataTable(
                folderNavigation: true,
                fullScreen: true,
                clickable: true,
                showActionsColumn: true,
                columns: Responsive.isMobile(context)
                    ? const ["Name"]
                    : const ["Name", "Size", "Last modified"],
                data: files.map((file) {
                  return Responsive.isMobile(context)
                      ? [file.name]
                      : [
                          file.name,
                          file.sizeToString,
                          file.type,
                        ];
                }).toList(),
                context: context,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return const Center(child: Text("No files found"));
            }
          },
        );
      },
    );
  }

  void refreshDataTable() {
    setState(() {}); // Trigger a rebuild of the widget
  }
}
