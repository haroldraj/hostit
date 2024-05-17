import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/card_size.dart';
import 'package:hostit_ui/constants/screen_size.dart';
import 'package:hostit_ui/service/storage_service.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class CustomDataTable extends StatefulWidget {
  final List<String> columns;
  final List<List<dynamic>> data;
  final bool showActionsColumn;
  final String buttonName;
  final BuildContext context;
  final bool clickable;
  final bool fullScreen;
  final bool withReturnFunction;

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
  });

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<bool> sortAscending = List.filled(5, false);
  int sortColumnIndex = 0;
  final _scrollController = ScrollController();

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
      //int columnIndex = entry.key;
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

    // Ajoutez la colonne d'actions si nécessaire
    if (widget.showActionsColumn) {
      result.add(const DataColumn(label: Text("Actions")));
    }

    return result;
  }

  List<DataRow> _buildRows() {
    return widget.data.map((rowData) {
      var cells = rowData
          .map(
            (cellData) => DataCell(
              Text(cellData ?? ''), // Utilisation de la valeur par défaut ''
            ),
          )
          .toList();

      // Ajoutez un bouton pour la colonne d'actions si nécessaire

      if (widget.showActionsColumn) {
        var fileName = rowData.isNotEmpty
            ? rowData[0] ??
                '' // Supposons que l'ID du joueur est dans la première colonne
            : '';

        cells.add(DataCell(
          ElevatedButton(
            style: ButtonStyle().copyWith(),
            onPressed: () {
              _handleDownloadFile(fileName);
            },
            child: Text(widget.buttonName),
          ),
        ));
      }

      return DataRow(
          onSelectChanged: (bool? selected) {
            if (widget.clickable && selected!) {
              if (!widget.withReturnFunction) {
                var fileName = rowData.isNotEmpty ? rowData[0] ?? '' : '';
                debugPrint("Row tapped");
                _handleOpenInNewTab(fileName);
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

      // ignore: unnecessary_type_check
      if (ascending) {
        return Comparable.compare(aValue, bValue);
      } else {
        return Comparable.compare(bValue, aValue);
      }
    });
    //Refresh la table
    setState(() {});
  }

  // Fonction pour gérer l'édition avec l'ID
  Future _handleDownloadFile(String fileName) async {
    debugPrint('Download file: $fileName');
    final url = Uri.parse(
      await _getDownloadUri(fileName),
    );
    final response = await http.get(url);
    final blob = html.Blob([response.bodyBytes]);
    final anchorElement = html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(blob).toString(),
    )..setAttribute('download', fileName);
    html.document.body!.children.add(anchorElement);
    anchorElement.click();
    html.document.body!.children.remove(anchorElement);
    print(response.bodyBytes.length);
  }

  // Fonction générique avec l'ID
  Future _handleOpenInNewTab(String fileName) async {
    html.AnchorElement(
      href: await _getDownloadUri(fileName),
    )
      ..target = 'blank' // to open a new tab/window
      //..download = fileName // to force download
      ..click();
    debugPrint('Open file in new Tab: $fileName');
  }

  Future<String> _getDownloadUri(String fileName) async {
    String userId = '1';
    final StorageService storageService = StorageService();
    String fileDownloadUri =
        await storageService.getFileDownloadUri(userId, fileName);
    return fileDownloadUri;
  }
}
