import 'package:flutter/material.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_info.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_types.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.home, title: 'Home', icon: Icons.home_filled),
  MenuInfo(MenuType.photos, title: 'Photos', icon: Icons.photo),
  MenuInfo(MenuType.folders, title: 'Folders', icon: Icons.folder),
];
