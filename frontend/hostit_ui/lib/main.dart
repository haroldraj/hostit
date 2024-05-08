import 'package:flutter/material.dart';
import 'package:hostit_ui/controllers/menu_app_controller.dart';
//import 'package:hostit_ui/widgets/navigation_menu.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_info.dart';
import 'package:hostit_ui/widgets/navigation_menu/components/menu_types.dart';
import 'package:hostit_ui/widgets/navigation_menu/navigation_menu.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOSTIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<MenuInfo>(
            create: (context) => MenuInfo(MenuType.home),
          ),
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: const NavigationMenu(),
      ),
    );
  }
}
