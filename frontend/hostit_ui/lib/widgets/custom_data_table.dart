import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/card_size.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/constants/screen_size.dart';
import 'package:hostit_ui/service/storage_service.dart';

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
  final StorageService _storageService = StorageService();
  List<List<String>> data = [];
  int userId = 1;
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
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: width,
      child: DataTable(
        showCheckboxColumn: false,
        columns: _buildColumns(),
        rows: _buildRows(),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    var result = widget.columns.asMap().entries.map((entry) {
      String column = entry.value;

      return DataColumn(
        label: Text(
          column,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onSort: (columnIndex, ascending) {
          if (columnIndex == sortColumnIndex) {
            ascending = !ascending;
          }
          _sort(columnIndex, ascending);
        },
      );
    }).toList();

    if (widget.showActionsColumn) {
      result.add(
        const DataColumn(
          label: Text(
            "Actions",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return result;
  }

  List<DataRow> _buildRows() {
    return widget.data.map((rowData) {
      var cells = rowData
          .map(
            (cellData) => DataCell(
              Text(cellData ?? ''),
            ),
          )
          .toList();
      if (widget.showActionsColumn) {
        var filePath = rowData.length > 1 ? rowData[4] ?? '' : '';
        ValueNotifier<bool> isDeleteHovered = ValueNotifier<bool>(false);
        ValueNotifier<bool> isDownloadHovered = ValueNotifier<bool>(false);
        cells.add(DataCell(
          Row(
            children: [
              MouseRegion(
                onHover: (_) => isDownloadHovered.value = true,
                onExit: (_) => isDownloadHovered.value = false,
                child: SizedBox(
                  width: 100,
                  height: 35,
                  child: FloatingActionButton(
                    elevation: 0,
                    hoverColor: Colors.blueAccent,
                    onPressed: () {
                      _handleDownloadFile(userId, filePath);
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isDownloadHovered,
                      builder: (context, value, child) {
                        return Text(
                          'Download',
                          style: TextStyle(color: value ? Colors.white : null),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Spacing.horizontal,
              MouseRegion(
                onHover: (_) => isDeleteHovered.value = true,
                onExit: (_) => isDeleteHovered.value = false,
                child: SizedBox(
                  width: 100,
                  height: 35,
                  child: FloatingActionButton(
                    elevation: 0,
                    hoverColor: CustomColors.primaryColor,
                    onPressed: () {
                      _handleDeleteFile(userId, filePath);
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isDeleteHovered,
                      builder: (context, value, child) {
                        return Text(
                          'Delete',
                          style: TextStyle(
                              color: value ? Colors.white : Colors.red),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      }

      return DataRow(
          onSelectChanged: (bool? selected) {
            if (widget.clickable && selected!) {
              if (!widget.withReturnFunction) {
                var filePath = rowData.isNotEmpty ? rowData[4] ?? '' : '';
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
    await _storageService.downloadFile(userId, filePath);
  }

  Future _handleDeleteFile(int userId, String filePath) async {
    await _storageService.deleteFile(userId, filePath);
  }

  Future _handleOpenInNewTab(int userId, String filePath) async {
    await _storageService.openFile(userId, filePath);
  }
}
