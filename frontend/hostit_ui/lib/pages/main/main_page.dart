import 'package:flutter/material.dart';
import 'package:hostit_ui/models/dropped_file.dart';
import 'package:hostit_ui/widgets/dropzone/dropped_file_widget.dart';
import 'package:hostit_ui/widgets/dropzone/dropzone_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DroppedFile? file;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DroppedFileWidget(file: file),
            const SizedBox(height: 16),
            SizedBox(
              height: 500,
              child: DropzoneWidget(
                onDroppedFile: (file) => setState(() {
                  this.file = file;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
