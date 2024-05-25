import 'package:hostit_ui/widgets/navigation_menu/components/menu_info.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_types.dart';
import 'package:hostit_ui/widgets/navigation_menu/navigation_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MenuInfo>(
          create: (context) => MenuInfo(MenuType.home),
        ),
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: const NavigationMenu(),
    );
  }
}
