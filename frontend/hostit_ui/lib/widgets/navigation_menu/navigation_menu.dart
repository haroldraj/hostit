import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';
import 'package:hostit_ui/pages/auth/sign%20out/sign_out_page.dart';
import 'package:hostit_ui/pages/home/home_page.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/add_files/add_files_widget.dart';
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
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                flex: 1,
                child: CustomDrawer(),
              ),
            Expanded(
              flex: 6,
              child: Container(
                color: CustomColors.backgroundgColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          !Responsive.isDesktop(context)
                              ? IconButton(
                                  onPressed: context
                                      .read<MenuAppController>()
                                      .controlMenu,
                                  icon: const Icon(Icons.menu),
                                )
                              : const SizedBox(),
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 35,
                                    child: FloatingActionButton(
                                      elevation: 0,
                                      onPressed: () => showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => const AddFiles(),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add),
                                          Text("Add Files  "),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.person),
                                ),
                                Text(
                                  UserService().getUsername(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                    SignOutPage.confirmation(context);
                                  },
                                  icon: const Icon(Icons.logout_outlined),
                                ),
                                Spacing.horizontal
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    /*Container(
                      height: 150,
                      width: 150,
                      color: Colors.red,
                    )*/
                    _buildMenuRoutes()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuRoutes() {
  return Consumer<MenuInfo>(
    builder: (BuildContext context, MenuInfo value, Widget? child) {
      if (value.menuType == MenuType.home) {
        return const HomePage();
      } else if (value.menuType == MenuType.photos) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'PHOTOS',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
        );
      } else {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: "Search Files",
        fillColor: Color.fromARGB(197, 226, 219, 230),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
