import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/file_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/custom_data_table.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FileService _fileService = FileService();
  int userId = UserService().getUserId();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<List<FileModel>>(
          future: _fileService.getUserFiles(userId),
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
  final List<FileModel>? files;
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
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search Files",
              fillColor: Color.fromARGB(197, 244, 237, 248),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              prefixIcon: Icon(Icons.search),
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
          fullScreen: true,
          clickable: true,
          showActionsColumn: true,
          columns: Responsive.isMobile(context)
              ? const ["Name"]
              : Responsive.isTablet(context)
                  ? const ["Name", "Size", "Date"]
                  : const ["Name", "Type", "Size", "Date", "Path"],
          data: widget.files
                  ?.where((file) => file.name!
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .map((file) => Responsive.isMobile(context)
                      ? [file.name]
                      : Responsive.isTablet(context)
                          ? [
                              file.name,
                              file.sizeToString,
                              file.uploadDateToString,
                            ]
                          : [
                              file.name,
                              file.contentType,
                              file.sizeToString,
                              file.uploadDateToString,
                              file.path
                            ])
                  .toList() ??
              [],
          context: context,
        ),
      ],
    );
  }
}
