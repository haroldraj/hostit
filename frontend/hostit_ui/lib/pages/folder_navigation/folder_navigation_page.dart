import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/folder_content_model.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/custom_data_table.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';

class FolderNavigationPage extends StatefulWidget {
  const FolderNavigationPage({super.key});

  @override
  State<FolderNavigationPage> createState() => _FolderNavigationPageState();
}

class _FolderNavigationPageState extends State<FolderNavigationPage> {
  final FolderService _folderService = FolderService();
  int userId = UserService().getUserId();
  String rootFolder = ".root";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.pageBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<List<FolderContentModel>>(
          future: _folderService.getFolderContent(userId, rootFolder),
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

class FileListWidget extends StatefulWidget {
  final List<FolderContentModel>? files;
  const FileListWidget({super.key, required this.files});

  @override
  State<FileListWidget> createState() => _FileListWidgetState();
}

class _FileListWidgetState extends State<FileListWidget> {
  final TextEditingController _searchController = TextEditingController();

  /*WebSocketChannel? _channel;

    @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse("${UrlConfig.baseApiUrl}/file-updates"),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Center(
            child: Text(
              'Welcome to Hostit, ${UserService().getUsername()}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
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
          // channel: _channel!,
          folderNavigation: true,
          fullScreen: true,
          clickable: true,
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
                            file.lastModifiedToString,
                          ],
                  )
                  .toList() ??
              [],

          context: context,
          //onRowClicked: (rowData)
        ),
      ],
    );
  }
}
