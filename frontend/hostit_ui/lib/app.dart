import 'package:flutter/material.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';
import 'package:hostit_ui/pages/main/components/navigation_menu/menu_info.dart';
import 'package:hostit_ui/pages/main/components/navigation_menu/menu_types.dart';
import 'package:hostit_ui/pages/auth/sign_in/sign_in_page.dart';
import 'package:hostit_ui/pages/main/main_menu_page.dart';
import 'package:hostit_ui/providers/folder_path_provider.dart';
import 'package:provider/provider.dart';
import 'package:hostit_ui/service/auth_service.dart';

class HostitApp extends StatefulWidget {
  const HostitApp({super.key});

  @override
  State<HostitApp> createState() => _HostitAppState();
}

class _HostitAppState extends State<HostitApp> {
  late bool _isTokenValid;

  @override
  void initState() {
    super.initState();
    _isTokenValid = AuthService().isTokenValid();
  }

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
        ChangeNotifierProvider(
          create: (context) => FolderPathProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'HOSTIT',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(),
          home: const MainMenu() //
          // _isTokenValid ? const MainMenu() : const SignInPage(),
          ),
    );
  }
}
