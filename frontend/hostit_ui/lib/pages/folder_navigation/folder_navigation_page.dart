/*import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/folder_content_model.dart';
import 'package:hostit_ui/pages/folder_navigation/components/file_list_widget.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/custom_data_table.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

class FolderNavigationPage extends StatefulWidget {
  const FolderNavigationPage({super.key});

  @override
  State<FolderNavigationPage> createState() => _FolderNavigationPageState();
}

class _FolderNavigationPageState extends State<FolderNavigationPage> {
  final FolderService _folderService = FolderService();
  int userId = UserService().getUserId();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.pageBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Consumer<FolderPathProvider>(
          builder: (context, folderPathProvider, child) {
            return FutureBuilder<List<FolderContentModel>>(
              future: _folderService.getFolderContent(
                  userId,
                  folderPathProvider.folderPath.isEmpty
                      ? ".root"
                      : folderPathProvider.folderPathToString),
              builder: (context, snapshot) {
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
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/pages/folder_navigation/components/file_list_widget.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:provider/provider.dart';

class FolderNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.pageBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Spacing.vertical,
            const FolderPathWidget(),
            Spacing.vertical,
            const SearchFieldWidget(),
            Spacing.vertical,
            const Expanded(child: FileListWidget()),
          ],
        ),
      ),
    );
  }
}

class FolderPathWidget extends StatelessWidget {
  const FolderPathWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderPathProvider>(
      builder: (context, folderPathProvider, child) {
        var folderPath = folderPathProvider.folderPath;
        return Container(
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
        );
      },
    );
  }
}

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onChanged: (value) {
          Provider.of<FolderPathProvider>(context, listen: false)
              .setSearchQuery(value);
        },
      ),
    );
  }
}
