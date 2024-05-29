import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';
import 'package:hostit_ui/pages/auth/sign%20out/sign_out_page.dart';
import 'package:hostit_ui/pages/home/home_page.dart';
import 'package:hostit_ui/pages/main/main_menu_page.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/add_files/add_files_widget.dart';
import 'package:hostit_ui/widgets/custom_box_dialog.dart';
import 'package:hostit_ui/widgets/custom_text_form_field.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/custom_drawer.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_info.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_types.dart';
import 'package:provider/provider.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController folderController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    FolderService folderService = FolderService();
    int userId = UserService().getUserId();

    Future<void> onCreatePressed() async {
      try {
        if (formKey.currentState!.validate()) {
          debugPrint("Creating new folder");
          String folderName = folderController.text.trim();
          bool isFolderCrated =
              await folderService.createFolder(userId, folderName);
          if (isFolderCrated) {
            Future.delayed(
              const Duration(seconds: 0),
              () {
                goTo(context, const MainMenu(), isReplaced: true);
              },
            );
          } else {
            Future.delayed(
              const Duration(seconds: 0),
              () {
                ShowDialog.error(context, 'Error');
              },
            );
          }
        }
      } catch (error) {
        debugPrint("Error $error");
      }
    }

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
                                  ),
                                  Spacing.horizontal,
                                  SizedBox(
                                    width: 150,
                                    height: 35,
                                    child: FloatingActionButton(
                                      elevation: 0,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            title: const Text("New folder"),
                                            content: Form(
                                              key: formKey,
                                              child: textFormField(
                                                  "Folder's name",
                                                  folderController),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  onCreatePressed();
                                                },
                                                child: const Text("Create"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add),
                                          Text("Create Folder"),
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
