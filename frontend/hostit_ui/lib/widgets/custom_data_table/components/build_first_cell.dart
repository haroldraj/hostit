import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostit_ui/constants/svg_file_type.dart';
import 'package:path/path.dart' as path;

Widget buildFirstCell(String cellData, bool isFolderNavigation) {
  List<String> parts = cellData.split('/');
  cellData = parts.last;
  return Row(
    children: [
      path.extension(cellData).isNotEmpty
          ? SvgPicture.asset(
              fileTypeToSvg.putIfAbsent(
                  path.extension(cellData).substring(1), () => unknownFileType),
              height: 20,
              width: 20,
            )
          : SvgPicture.asset(
              folderSvg,
              height: 25,
              width: 25,
            ),
      const SizedBox(width: 15),
      Text(cellData),
    ],
  );
}
