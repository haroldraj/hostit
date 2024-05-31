import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/pages/folder_navigation/components/file_list_widget.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:provider/provider.dart';

class FolderNavigationPage extends StatelessWidget {
  const FolderNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.pageBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Spacing.vertical,
            FolderPathWidget(),
            Spacing.vertical,
            SearchFieldWidget(),
            Spacing.vertical,
            Expanded(child: FileListWidget()),
          ],
        ),
      ),
    );
  }
}

class FolderPathWidget extends StatelessWidget {
  const FolderPathWidget({super.key});

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
  const SearchFieldWidget({super.key});

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
