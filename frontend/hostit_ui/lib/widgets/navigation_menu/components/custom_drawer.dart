import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_info.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_items.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Responsive.isDesktop(context)
              ? Radius.zero
              : const Radius.circular(15),
        ),
      ),
      child: ListView.builder(
        itemCount: menuItems.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const DrawerHeader(
              child: Center(
                child: SizedBox(
                  width: 150,
                  child: Image(
                    image: AssetImage('assets/images/logo_hostit.png'),
                  ),
                ),
              ),
            );
          } else {
            final currentMenuInfo = menuItems[index - 1];
            return buildMenuButton(currentMenuInfo);
          }
        },
      ),
    );
  }
}

Widget buildMenuButton(MenuInfo currentMenuInfo) {
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
              ? CustomColors.primaryColor.withOpacity(0.6)
              : null,
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
