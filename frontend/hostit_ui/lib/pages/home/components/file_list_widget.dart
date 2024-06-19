import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/widgets/custom_data_table/custom_data_table.dart';

class FileListWidget extends StatefulWidget {
  final List<FileModel>? files;
  const FileListWidget({super.key, required this.files});

  @override
  State<FileListWidget> createState() => _FileListWidgetState();
}

class _FileListWidgetState extends State<FileListWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          fullScreen: true,
          clickable: true,
          showActionsColumn: true,
          columns: Responsive.isMobile(context)
              ? const ["Name"]
              : Responsive.isTablet(context)
                  ? const ["Name", "Path"]
                  : const ["Name", "Size", "Date", "Path"],
          data: widget.files
                  ?.where((file) => file.name!
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .map(
                    (file) => Responsive.isMobile(context)
                        ? [file.path]
                        : Responsive.isTablet(context)
                            ? [
                                file.name,
                                file.path,
                              ]
                            : [
                                file.name,
                                file.sizeToString,
                                file.uploadDateToString,
                                file.path,
                              ],
                  )
                  .toList() ??
              [],
          context: context,
        ),
      ],
    );
  }
}
