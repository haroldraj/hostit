import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';
import 'package:hostit_ui/pages/main/components/navigation_menu/menu_routes.dart';
import 'package:hostit_ui/providers/file_data_model_provider.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:hostit_ui/responsive.dart';
import 'package:hostit_ui/service/folder_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/pages/main/components/add_files_widget.dart';
import 'package:hostit_ui/widgets/custom_box_dialog.dart';
import 'package:hostit_ui/widgets/custom_text_form_field.dart';
import 'package:hostit_ui/pages/main/components/navigation_menu/custom_drawer.dart';
import 'package:provider/provider.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController folderController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    FolderService folderService = FolderService();

    void close() {
      Navigator.pop(context);
    }

    Future<void> onCreatePressed(String folderPath) async {
      try {
        if (formKey.currentState!.validate()) {
          debugPrint("Creating new folder");
          String folderName = "$folderPath/${folderController.text.trim()}";
          bool isFolderCrated = await folderService.createFolder(folderName);
          if (isFolderCrated) {
            var fileDataModelProvider =
                // ignore: use_build_context_synchronously
                Provider.of<FileDataModelProvider>(context, listen: false);
            await fileDataModelProvider.fetchFiles();
            close();
            folderController.clear();
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

    return Consumer<FolderPathProvider>(
        builder: (context, folderPathProvider, child) {
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
                  color: CustomColors.appBgColor,
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
                                        backgroundColor:
                                            CustomColors.buttonBgColor,
                                        elevation: 0,
                                        onPressed: () => showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) =>
                                              const AddFiles(),
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
                                      width: 120,
                                      height: 35,
                                      child: FloatingActionButton(
                                        backgroundColor:
                                            CustomColors.buttonBgColor,
                                        elevation: 0,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  "New folder in ${folderPathProvider.folderPathToString}"),
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
                                                    onCreatePressed(
                                                        folderPathProvider
                                                            .folderPathToString);
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
                                            Text("Create Folder "),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.person),
                                  ),
                                  Text(
                                    UserService().getUsername(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Spacing.horizontal
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      buildMenuRoutes()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
