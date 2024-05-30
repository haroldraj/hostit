import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/pages/home/components/file_list_widget.dart';
import 'package:hostit_ui/service/file_service.dart';
import 'package:hostit_ui/service/user_service.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.pageBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const MyHostitPage(),
      ),
    );
  }
}

class MyHostitPage extends StatelessWidget {
  const MyHostitPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FileService fileService = FileService();
    int userId = UserService().getUserId();

    return FutureBuilder<List<FileModel>>(
      future: fileService.getUserFiles(userId),
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: customCircularProgressIndicator("Loading file list..."),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var files = snapshot.data;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Spacing.vertical,
                  FileListWidget(files: files),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No files found"));
          }
        } on Exception catch (error) {
          return Center(
            child: Text("Error: $error"),
          );
        }
      },
    );
  }
}
