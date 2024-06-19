import 'package:flutter/material.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:provider/provider.dart';

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
                    style: TextStyle(fontSize: 20),
                  ),
              ];
            }).toList(),
          ),
        );
      },
    );
  }
}
