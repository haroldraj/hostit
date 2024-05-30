/*import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/folder_content_model.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/widgets/custom_data_table.dart';
import 'package:provider/provider.dart';

class FileListWidget extends StatefulWidget {
  final List<FolderContentModel>? files;
  const FileListWidget({super.key, required this.files});

  @override
  State<FileListWidget> createState() => _FileListWidgetState();
}

class _FileListWidgetState extends State<FileListWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderPathProvider>(
      builder: (context, folderPathProvider, child) {
        var folderPath = folderPathProvider.folderPath;
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25, left: 15),
              child: Row(
                children: folderPath.asMap().entries.expand((entry) {
                  int idx = entry.key;
                  String folder = entry.value;

                  return [
                    TextButton(
                      onPressed: () {
                        folderPathProvider
                            .setFolderPath(folderPath.sublist(0, idx + 1));
                      },
                      child: Text(
                        folder,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    if (idx < folderPath.length - 1)
                      const Text(
                        ' > ',
                        style: TextStyle(fontSize: 40),
                      ),
                  ];
                }).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Files",
                  fillColor: CustomColors.searchFeldColor,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Spacing.vertical,
            CustomDataTable(
              folderNavigation: true,
              fullScreen: true,
              clickable: false,
              showActionsColumn: true,
              columns: Responsive.isMobile(context)
                  ? const ["Name"]
                  : const ["Name", "Size", "Last modified"],
              data: widget.files
                      ?.where((file) => file.name!
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .map(
                        (file) => Responsive.isMobile(context)
                            ? [file.name]
                            : [
                                file.name,
                                file.sizeToString,
                                file.type,
                              ],
                      )
                      .toList() ??
                  [],
              context: context,
            ),
          ],
        );
      },
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/folder_content_model.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/custom_data_table.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

class FileListWidget extends StatefulWidget {
  const FileListWidget({Key? key}) : super(key: key);

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
                key: GlobalKey(),
                folderNavigation: true,
                fullScreen: true,
                clickable: false,
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
