import 'package:flutter/material.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_types.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String? title;
  IconData? icon;

  MenuInfo(this.menuType, {this.title, this.icon});

  updateMenu(MenuInfo menuInfo) {
    menuType = menuInfo.menuType;
    title = menuInfo.title;
    icon = menuInfo.icon;

    notifyListeners();
  }
}
