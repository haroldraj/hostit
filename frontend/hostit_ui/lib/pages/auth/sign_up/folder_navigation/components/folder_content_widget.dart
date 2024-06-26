import 'package:flutter/material.dart';
import 'package:hostit_ui/models/folder_content_model.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:hostit_ui/widgets/custom_data_table/custom_data_table.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

class FolderContentWidget extends StatefulWidget {
  const FolderContentWidget({super.key});

  @override
  State<FolderContentWidget> createState() => _FolderContentWidgetState();
}

class _FolderContentWidgetState extends State<FolderContentWidget> {
  final FolderService _folderService = FolderService();

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderPathProvider>(
      builder: (context, folderPathProvider, child) {
        return FutureBuilder<List<FolderContentModel>>(
          future: _folderService
              .getFolderContent(folderPathProvider.folderPathToString),
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
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: CustomDataTable(
                  folderNavigation: true,
                  fullScreen: true,
                  clickable: true,
                  showActionsColumn: true,
                  columns: Responsive.isMobile(context)
                      ? const ["Name"]
                      : const ["Name", "Size", "Type"],
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
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return const Center(child: Text("No file found"));
            }
          },
        );
      },
    );
  }
}
