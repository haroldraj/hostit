import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/pages/auth/sign_up/folder_navigation/components/folder_content_widget.dart';
import 'package:hostit_ui/pages/auth/sign_up/folder_navigation/components/folder_path_widget.dart';
import 'package:hostit_ui/widgets/search_field_widget.dart';

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
            Expanded(child: FolderContentWidget()),
          ],
        ),
      ),
    );
  }
}
