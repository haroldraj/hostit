import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/card_size.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/constants/screen_size.dart';
import 'package:hostit_ui/providers/file_data_model_provider.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/file_service.dart';
import 'package:hostit_ui/widgets/custom_data_table/components/build_first_cell.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class CustomDataTable extends StatefulWidget {
  final List<String> columns;
  final List<List<dynamic>> data;
  final bool showActionsColumn;
  final BuildContext context;
  final bool clickable;
  final bool fullScreen;
  final bool withReturnFunction;
  final bool folderNavigation;
  final bool showCheckboxColumn;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.data,
    required this.context,
    this.showActionsColumn = false,
    this.clickable = false,
    this.fullScreen = false,
    this.withReturnFunction = false,
    this.folderNavigation = false,
    this.showCheckboxColumn = false,
  });

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<bool> sortAscending = List.filled(5, false);
  int sortColumnIndex = 0;
  final _scrollController = ScrollController();
  final FileService _fileService = FileService();
  List<bool> selectedRows = [];

  @override
  void initState() {
    super.initState();
    selectedRows = List<bool>.filled(widget.data.length, false);
  }

  void _close() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: _buildDataTable(
          widget.fullScreen
              ? ScreenSize.width(context) / 1.2
              : CardSize.width(context),
        ),
      ),
    );
  }

  Widget _buildDataTable(double width) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: Responsive.isMobile(context)
          ? max(width, MediaQuery.of(context).size.width)
          : Responsive.isTablet(context)
              ? width
              : min(width, MediaQuery.of(context).size.width),
      child: DataTable(
        columnSpacing: 0,
        horizontalMargin: 10,
        showCheckboxColumn: widget.showCheckboxColumn,
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
        label: _buildColumnLabel(column, columnIndex),
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

  Widget _buildColumnLabel(String column, int columnIndex) {
    return Row(
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
    );
  }

  List<DataRow> _buildRows() {
    return widget.data.asMap().entries.map((entry) {
      int index = entry.key;
      List<dynamic> rowData = entry.value;
      String filePath = widget.folderNavigation ? rowData.first : rowData.last;
      String fileOrFolderName = rowData.first;

      return DataRow(
        selected: selectedRows[index],
        onSelectChanged: (bool? value) {
          if (widget.clickable) {
            debugPrint("Row tapped");
            _handleOpenFile(filePath, fileOrFolderName);
          }
        },
        cells: _buildCells(rowData, index),
      );
    }).toList();
  }

  List<DataCell> _buildCells(List<dynamic> rowData, int rowIndex) {
    var cells = rowData.asMap().entries.map((entry) {
      int cellIndex = entry.key;
      var cellData = entry.value;
      return DataCell(
        cellIndex == 0
            ? buildFirstCell(cellData, widget.folderNavigation)
            : Text(cellData ?? ''),
      );
    }).toList();

    if (widget.showActionsColumn) {
      cells.add(_buildActionCell(rowData));
    }

    return cells;
  }

  DataCell _buildActionCell(List<dynamic> rowData) {
    String filePath = widget.folderNavigation ? rowData.first : rowData.last;
    return DataCell(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionIcon(Icons.download_sharp, "Download", () {
            _handleDownloadFile(filePath);
          }),
          _buildActionIcon(Icons.delete_sharp, "Delete", () {
            _handleDeleteFile(filePath);
          }),
        ],
      ),
    );
  }

  Widget _buildActionIcon(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon,
            color: tooltip == "Delete" ? Colors.red : Colors.deepPurple),
        onPressed: onPressed,
      ),
    );
  }

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      sortAscending[columnIndex] = ascending;
      sortColumnIndex = columnIndex;

      widget.data.sort((a, b) {
        var aValue = a[sortColumnIndex];
        var bValue = b[sortColumnIndex];

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return ascending ? 1 : -1;
        if (bValue == null) return ascending ? -1 : 1;

        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Future<void> _handleDownloadFile(String filePath) async {
    await _fileService.downloadFile(filePath);
  }

  Future<void> _handleDeleteFile(String filePath) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          "Confirmation",
          style: TextStyle(color: CustomColors.redColor),
        ),
        content: Text("Do you really want to delete : $filePath ?"),
        actions: [
          TextButton(
            onPressed: () => _close(),
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () async {
              bool isDeleted = await _fileService.deleteFile(filePath);
              if (isDeleted) {
                var fileDataModelProvider =
                    // ignore: use_build_context_synchronously
                    Provider.of<FileDataModelProvider>(context, listen: false);
                fileDataModelProvider.fetchFiles();
                _close();
              }
            },
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleOpenFile(String filePath, String fileOrFolderName) async {
    bool isAFolder = path.extension(fileOrFolderName).isEmpty;

    if (isAFolder) {
      var folderPathProvider =
          Provider.of<FolderPathProvider>(context, listen: false);

      folderPathProvider.addFolderPath(fileOrFolderName);
    } else {
      await _fileService.openFile(filePath);
    }
  }
}
