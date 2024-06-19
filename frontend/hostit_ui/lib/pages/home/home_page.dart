import 'package:flutter/material.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/pages/home/components/file_list_widget.dart';
import 'package:hostit_ui/pages/home/components/welcoming_text_widget.dart';
import 'package:hostit_ui/providers/file_data_model_provider.dart';
import 'package:hostit_ui/widgets/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

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
        child: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Spacing.vertical,
              WelcomingTextWidget(),
              Spacing.vertical,
              //  SearchFieldWidget(),
              //Spacing.vertical,
              MyHostitPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHostitPage extends StatefulWidget {
  const MyHostitPage({
    super.key,
  });

  @override
  State<MyHostitPage> createState() => _MyHostitPageState();
}

class _MyHostitPageState extends State<MyHostitPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<FileDataModelProvider>(context, listen: false).fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FileDataModelProvider>(
        builder: (context, fileDataModelProvider, child) {
      if (fileDataModelProvider.isLoading!) {
        return Center(
          child: customCircularProgressIndicator("Loading file list..."),
        );
      } else if (fileDataModelProvider.files.isEmpty) {
        return const Center(
          child: Text("No file found."),
        );
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Spacing.vertical,
              FileListWidget(files: fileDataModelProvider.files),
            ],
          ),
        );
      }
    });
  }
}
