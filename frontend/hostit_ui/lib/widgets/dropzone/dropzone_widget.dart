import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:hostit_ui/constants/custom_colors.dart';
import 'package:hostit_ui/constants/helpers.dart';
import 'package:hostit_ui/models/file_model.dart';
import 'package:hostit_ui/pages/main/main_menu_page.dart';
import 'package:hostit_ui/service/storage_service.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

class DropzoneWidget extends StatefulWidget {
  //final ValueChanged<DroppedFile> onDroppedFile;

  const DropzoneWidget({
    super.key,
    //required this.onDroppedFile,
  });

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  final Logger _logger = Logger();
  late DropzoneViewController controller;
  bool isHighlighted = false;
  FilePickerResult? _filePickerResult;
  StorageService storageService = StorageService();
  ValueNotifier<bool> isCancelHovered = ValueNotifier<bool>(false);

  void _close() {
    Navigator.pop(context);
  }

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
                  onPressed: () => uploadFile(),
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
                Spacing.vertical,
                MouseRegion(
                  onHover: (_) => isCancelHovered.value = true,
                  onExit: (_) => isCancelHovered.value = false,
                  child: SizedBox(
                    width: 100,
                    height: 35,
                    child: FloatingActionButton(
                      heroTag: 'unitqueTag2',
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(240, 248, 204, 204),
                      hoverColor: CustomColors.primaryColor,
                      onPressed: () {
                        _close();
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isCancelHovered,
                        builder: (context, value, child) {
                          return Text(
                            'Cancel',
                            style: TextStyle(
                                color: value ? Colors.white : Colors.red,
                                fontSize: 18),
                          );
                        },
                      ),
                    ),
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
    FileModel fileModel = FileModel(
      bytes: await controller.getFileData(event),
      name: event.name,
      contentType: await controller.getFileMIME(event),
    );
    await storageService.uploadBytes(fileModel);
    _close();
    setState(() {
      isHighlighted = false;
    });
  }

  Future uploadFile() async {
    _filePickerResult = await FilePicker.platform.pickFiles();
    if (_filePickerResult == null) {
      _logger.i("No file selected");
    } else {
      FileModel fileModel = FileModel(
        bytes: _filePickerResult!.files.first.bytes,
        name: _filePickerResult!.files.first.name,
        contentType: lookupMimeType(_filePickerResult!.files.first.extension!),
      );
      await storageService.uploadBytes(fileModel);
      _close();
      if (mounted) {
        goTo(context, const MainMenu(), isReplaced: true);
      }
    }
  }
}
