import 'package:flutter/material.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';
import 'package:hostit_ui/pages/main/main_page.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/custom_drawer.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_info.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_types.dart';
import 'package:provider/provider.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const CustomDrawer(),
      body: Row(
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              flex: 1,
              child: CustomDrawer(),
            ),
          Expanded(
            flex: 6,
            child: buildMenuRoutes(),
          )
        ],
      ),
    );
  }
}

Widget buildMenuRoutes() {
  return Consumer<MenuInfo>(
    builder: (BuildContext context, MenuInfo value, Widget? child) {
      if (value.menuType == MenuType.home) {
        return const Center(
          child: Text(
            'HOME',
            style: TextStyle(fontSize: 50),
          ),
        );
      } else if (value.menuType == MenuType.addFiles) {
        return const MainPage();
      } else if (value.menuType == MenuType.photos) {
        return const Center(
          child: Text(
            'PHOTOS',
            style: TextStyle(fontSize: 50),
          ),
        );
      } else {
        return const Center(
          child: Text(
            'FOLDERS',
            style: TextStyle(fontSize: 50),
          ),
        );
      }
    },
  );
}
