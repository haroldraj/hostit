import 'package:flutter/material.dart';
import 'package:hostit_ui/widgets/dropzone/dropzone_widget.dart';

class AddFiles extends StatefulWidget {
  const AddFiles({super.key});

  @override
  State<AddFiles> createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
        content: SingleChildScrollView(
      child: SizedBox(
        width: 500,
        height: 500,
        child: DropzoneWidget(),
      ),
    ));
    /*Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(25),
      child: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            SizedBox(
              height: 500,
              child: DropzoneWidget(),
            ),
          ],
        ),
      ),
    );*/
  }
}
