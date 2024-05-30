import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
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
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.pageBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'FOLDERS',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
        );
      }
    },
  );
}
