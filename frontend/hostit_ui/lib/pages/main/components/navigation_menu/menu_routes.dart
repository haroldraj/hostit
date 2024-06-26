import 'package:flutter/material.dart';
import 'package:hostit_ui/pages/auth/sign_up/folder_navigation/folder_navigation_page.dart';
import 'package:hostit_ui/pages/home/home_page.dart';
import 'package:hostit_ui/pages/main/components/navigation_menu/menu_info.dart';
import 'package:hostit_ui/pages/main/components/navigation_menu/menu_types.dart';
import 'package:provider/provider.dart';

Widget buildMenuRoutes() {
  return Consumer<MenuInfo>(
    builder: (BuildContext context, MenuInfo value, Widget? child) {
      if (value.menuType == MenuType.home) {
        return const HomePage();
      } else {
        return const FolderNavigationPage();
      }
    },
  );
}
