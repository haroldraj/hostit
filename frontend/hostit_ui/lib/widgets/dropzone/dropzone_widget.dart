// ignore_for_file: avoid_print

import 'dart:io';
import 'package:hostit_ui/constants/url_config.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:hostit_ui/models/dropped_file.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class FileUploader {
  static Future<String?> uploadBytes(
      List<int> bytes, String filename, String contenType, String url) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: MediaType(
              contenType.split('/').first, contenType.split('/').last),
        ),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        // File uploaded successfully
        return response.stream.bytesToString();
      } else {
        // Error uploading file
        print('Failed to upload file: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception while uploading file: $e');
      return null;
    }
  }
}

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;

  const DropzoneWidget({super.key, required this.onDroppedFile});

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController controller;
  bool isHighlighted = false;
  FilePickerResult? _filePickerResult;
  final String _baseUrl = UrlConfig.baseStorageUrl;

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
                    _filePickerResult = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png', 'txt', 'pdf', 'doc'],
                    );
                    if (_filePickerResult == null) {
                      print("No file selected");
                    } else {
                      //print("name: ${_filePickerResult!.files.first.name}");
                      //print("size: ${_filePickerResult!.files.first.size} B");
                      //print("size: ${_filePickerResult!.files.first.bytes} B");
                      List<int> fileBytes =
                          _filePickerResult!.files.first.bytes!;
                      //print(fileBytes);
                      String uploadUrl = "$_baseUrl/upload";
                      String filename = _filePickerResult!.files.first.name;
                      String? mimeType = lookupMimeType(
                          _filePickerResult!.files.first.extension!);
                      String? response = await FileUploader.uploadBytes(
                          fileBytes, filename, mimeType!, uploadUrl);
                      print(mimeType);
                      if (response != null) {
                        print(
                            'File uploaded successfully. Response: $response');
                      } else {
                        print('Failed to upload file');
                      }
                    }
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
    final size = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    final fileBytes = await controller.getFileData(event);

    //print('Name: $name');
    //print('Mime: $mime');
    //print('Sizes: $size');
    //print(path);
    String uploadUrl = "$_baseUrl/upload";
    String? response =
        await FileUploader.uploadBytes(fileBytes, name, mime, uploadUrl);
    if (response != null) {
      print('File uploaded successfully. Response: $response');
    } else {
      print('Failed to upload file');
    }
    final droppedFile = DroppedFile(
      url: url,
      name: name,
      mime: mime,
      bytes: size,
    );

    widget.onDroppedFile(droppedFile);
    setState(() {
      isHighlighted = false;
    });
  }
}
