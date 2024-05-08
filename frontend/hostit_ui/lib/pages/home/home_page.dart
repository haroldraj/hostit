import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_color.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';
import 'package:hostit_ui/pages/main/main_page.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_info.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_items.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_types.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Responsive.isDesktop(context) ? Container() : null,
      ),*/
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: Drawer(
        child: ListView.builder(
          itemCount: menuItems.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // First item is the header
              return const DrawerHeader(
                child: Center(child: Text('Drawer Header')),
              );
            } else {
              // Remaining items are menu buttons
              final currentMenuInfo = menuItems[index - 1];
              return buildMenuButtons(currentMenuInfo);
            }
          },
        ),
      ),
      body: Row(
        children: [
          if (Responsive.isDesktop(context))
            Expanded(
              flex: 1,
              child: Drawer(
                backgroundColor: Colors.white,
                elevation: 1,
                child: ListView.builder(
                  itemCount: menuItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // First item is the header
                      return const DrawerHeader(
                        child: Center(
                          child: SizedBox(
                            width: 150,
                            child: Image(
                              image:
                                  AssetImage('assets/images/logo_hostit.png'),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Remaining items are menu buttons
                      final currentMenuInfo = menuItems[index - 1];
                      return buildMenuButtons(currentMenuInfo);
                    }
                  },
                ),
              ),
            ),
          Expanded(
              flex: 6,
              child: Consumer<MenuInfo>(
                builder: (BuildContext context, MenuInfo value, Widget? child) {
                  if (value.menuType == MenuType.home) {
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
              ))
        ],
      ),
    );
  }
}

Widget buildMenuButtons(MenuInfo currentMenuInfo) {
  return Consumer<MenuInfo>(
    builder: (BuildContext context, MenuInfo value, Widget? child) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          hoverColor: CustomColors.primaryColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          tileColor: currentMenuInfo.menuType == value.menuType
              ? CustomColors.primaryColor
                  .withOpacity(0.6) // Change background color for selected item
              : null, // Use null for default color
          onTap: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
            if (!Responsive.isDesktop(context)) {
              Navigator.pop(context);
            }
          },
          leading: Icon(currentMenuInfo.icon),
          title: Text(currentMenuInfo.title!),
        ),
      );
    },
  );
}
