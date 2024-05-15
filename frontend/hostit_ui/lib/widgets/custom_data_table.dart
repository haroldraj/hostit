import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/card_size.dart';
import 'package:hostit_ui/constants/screen_size.dart';

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
    return SizedBox(
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
            onPressed: () {
              // Utilisez un switch pour déterminer quelle fonction exécuter
              switch (widget.buttonName) {
                case 'Edit':
                  _handleDownloadFile(fileName);
                  break;
                // Ajoutez d'autres cas au besoin
                default:
                  _handleGenericAction(fileName);
              }
            },
            child: Text(widget.buttonName),
          ),
        ));
      }

      return DataRow(
          onSelectChanged: (bool? selected) {
            if (widget.clickable && selected!) {
              if (!widget.withReturnFunction) {
                debugPrint("Row tapped");
                /*String playerId = widget.playerNameId[rowData[0]]!;
                String playerName = widget.playerNameId.keys.firstWhere(
                    (key) => widget.playerNameId[key] == playerId,
                    orElse: () => "");
                _handleViewProfile(playerId, playerName, widget.isFromApi);*/
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
      if (aValue is String && bValue is String) {
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      } else if (aValue is int && bValue is int) {
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      } else {
        // Gérer d'autres types de données si nécessaire
        return 0;
      }
    });
    //Refresh la table
    setState(() {});
  }

  // Fonction pour gérer l'édition avec l'ID
  void _handleDownloadFile(String fileName) {
    debugPrint('Download file button pressed for player with ID: $fileName');
    // Ajoutez le code pour l'édition ici
  }

  // Fonction générique avec l'ID
  void _handleGenericAction(String fileName) {
    debugPrint('Generic action button pressed for player with ID: $fileName');
    // Ajoutez le code pour l'action générique ici
  }
}
