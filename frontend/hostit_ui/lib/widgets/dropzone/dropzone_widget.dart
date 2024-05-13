// ignore_for_file: avoid_print

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:hostit_ui/models/dropped_file.dart';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;

  const DropzoneWidget({super.key, required this.onDroppedFile});

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController controller;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final colorButton = isHighlighted ? Colors.blue : Colors.green.shade300;

    return buildDecoration(
      child: Stack(
        fit: StackFit.expand,
        children: [
          DropzoneView(
            onDrop: acceptFile,
            onCreated: (controller) => this.controller = controller,
            onHover: () => setState(() {
              isHighlighted = true;
            }),
            onLeave: () => setState(() {
              isHighlighted = false;
            }),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload,
                  size: 80,
                  color: Colors.white,
                ),
                const Text(
                  'Drop Files here',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 64,
                        vertical: 15,
                      ),
                      backgroundColor: colorButton),
                  onPressed: () async {
                    final events = await controller.pickFiles();
                    if (events.isEmpty) return;

                    acceptFile(events.first);
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 32,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Choose Files',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDecoration({required Widget child}) {
    final colorBackground = isHighlighted ? Colors.blue : Colors.green;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: colorBackground,
        padding: const EdgeInsets.all(10),
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.white,
          strokeWidth: 3,
          padding: EdgeInsets.zero,
          dashPattern: const [8, 4],
          radius: const Radius.circular(10),
          child: child,
        ),
      ),
    );
  }

  Future acceptFile(dynamic event) async {
    final name = event.name;
    final mime = await controller.getFileMIME(event); //type of the file
    final bytes = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);

    print('Name: $name');
    print('Mime: $mime');
    print('Bytes: $bytes');
    print('Url: $url');

    final droppedFile = DroppedFile(
      url: url,
      name: name,
      mime: mime,
      bytes: bytes,
    );

    widget.onDroppedFile(droppedFile);
    setState(() {
      isHighlighted = false;
    });
  }
}
