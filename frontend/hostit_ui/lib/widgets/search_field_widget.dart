import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:provider/provider.dart';

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
