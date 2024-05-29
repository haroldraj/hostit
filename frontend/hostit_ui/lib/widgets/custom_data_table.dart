import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/card_size.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/constants/screen_size.dart';
import 'package:hostit_ui/constants/svg_file_type.dart';
import 'package:hostit_ui/pages/main/main_menu_page.dart';
import 'package:hostit_ui/service/file_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_svg/flutter_svg.dart';

class CustomDataTable extends StatefulWidget {
  final List<String> columns;
  final List<List<dynamic>> data;
  final bool showActionsColumn;
  final String buttonName;
  final BuildContext context;
  final bool clickable;
  final bool fullScreen;
  final bool withReturnFunction;
  // final WebSocketChannel channel;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.data,
    required this.context,
    this.showActionsColumn = false,
    this.buttonName = "",
    this.clickable = false,
    this.fullScreen = false,
    this.withReturnFunction = false,
    // required this.channel,
  });

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<bool> sortAscending = List.filled(5, false);
  int sortColumnIndex = 0;
  final _scrollController = ScrollController();
  final FileService _fileService = FileService();
  List<List<String>> data = [];
  int userId = UserService().getUserId();
/*
  @override
  void initState() {
    super.initState();
    widget.channel.stream.listen((message) {
     setState(() {
        // Split the message into parts
        List<String> parts = message.split(': ');
        // Check if the message has the expected format
        if (parts.length == 2) {
          if (parts[0] == 'File uploaded') {
            // Add the filename to the data
            data.add([parts[1]]);
          } else if (parts[0] == 'File deleted') {
            // Remove the filepath from the data
            data.removeWhere((element) => element.contains(parts[1]));
          }
        }
      });
    });
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: widget.fullScreen
              ? _buildDataTable(ScreenSize.width(context) / 1.2)
              : _buildDataTable(CardSize.width(context))),
    );
  }

  Widget _buildDataTable(double width) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      width: width,
      child: DataTable(
        columnSpacing: 0,
        horizontalMargin: 10,
        showCheckboxColumn: false,
        columns: _buildColumns(),
        rows: _buildRows(),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    var result = widget.columns.asMap().entries.map((entry) {
      int columnIndex = entry.key;
      String column = entry.value;

      return DataColumn(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              column,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacing.horizontal,
            if (columnIndex == sortColumnIndex)
              Icon(
                sortAscending[columnIndex]
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 18,
              ),
          ],
        ),
        onSort: (columnIndex, ascending) {
          if (columnIndex == sortColumnIndex) {
            ascending = !sortAscending[columnIndex];
          } else {
            ascending = true;
          }
          _sort(columnIndex, ascending);
        },
      );
    }).toList();

    if (widget.showActionsColumn) {
      result.add(
        const DataColumn(
          label: Flexible(
            child: Center(
              child: Text(
                "Actions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }

    return result;
  }

  List<DataRow> _buildRows() {
    return widget.data.map((rowData) {
      var cells = rowData
          .asMap()
          .map(
            (index, cellData) => MapEntry(
              index,
              DataCell(
                index == 0
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            fileTypeToSvg.putIfAbsent(
                                path.extension(cellData).substring(1),
                                () => unknownFileType),
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 15),
                          Text(cellData ?? ''),
                        ],
                      )
                    : Text(cellData ?? ''),
              ),
            ),
          )
          .values
          .toList();
      var filePath = rowData.last;
      if (widget.showActionsColumn) {
        cells.add(DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.download_sharp,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  _handleDownloadFile(userId, filePath);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_sharp,
                  color: Colors.red,
                ),
                onPressed: () {
                  _handleDeleteFile(userId, filePath);
                },
              ),
            ],
          ),
        ));
      }

      return DataRow(
          onSelectChanged: (bool? selected) {
            if (widget.clickable && selected!) {
              if (!widget.withReturnFunction) {
                // var filePath = rowData.isNotEmpty ? rowData[4] ?? '' : '';
                debugPrint("Row tapped");
                _handleOpenInNewTab(userId, filePath);
              }
            }
          },
          cells: cells);
    }).toList();
  }

  void _sort(int columnIndex, bool ascending) {
    sortAscending[columnIndex] = ascending;
    sortColumnIndex = columnIndex;

    widget.data.sort((a, b) {
      var aValue = a[sortColumnIndex];
      var bValue = b[sortColumnIndex];

      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return ascending ? 1 : -1;
      if (bValue == null) return ascending ? -1 : 1;

      if (ascending) {
        return Comparable.compare(aValue, bValue);
      } else {
        return Comparable.compare(bValue, aValue);
      }
    });
    setState(() {});
  }

  Future _handleDownloadFile(int userId, String filePath) async {
    await _fileService.downloadFile(userId, filePath);
  }

  Future _handleDeleteFile(int userId, String filePath) async {
    bool isDeleted = await _fileService.deleteFile(userId, filePath);
    if (isDeleted) {
      // ignore: use_build_context_synchronously
      goTo(context, const MainMenu(), isReplaced: true);
    }
  }

  Future _handleOpenInNewTab(int userId, String filePath) async {
    await _fileService.openFile(userId, filePath);
  }
}
