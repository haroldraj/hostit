/*import 'package:flutter/material.dart';
import 'package:hostit_ui/models/file_model.dart';

class DroppedFileWidget extends StatelessWidget {
  final DroppedFile? file;

  const DroppedFileWidget({
    super.key,
    required this.file,
  });
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildImage(),
          const SizedBox(width: 10),
          if (file != null) buildFileDetails(file!),
        ],
      );

  Widget buildFileDetails(DroppedFile file) {
    const style = TextStyle(fontSize: 20);

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            file.name,
            style: style.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          Text(file.mime, style: style),
          const SizedBox(height: 8),
          Text(file.size, style: style),
        ],
      ),
    );
  }

  Widget buildImage() {
    if (file == null) return buildEmptyFile('No File');
    return Image.network(
      file!.url,
      width: 250,
      height: 250,
      fit: BoxFit.fill,
      errorBuilder: (context, error, _) => buildEmptyFile('No Preview'),
    );
  }

  Widget buildEmptyFile(String text) => Container(
        width: 250,
        height: 250,
        color: Colors.blue.shade300,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
}
*/