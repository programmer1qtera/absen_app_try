import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras.first, ResolutionPreset.medium);
    await controller?.initialize();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<File> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String directoryPath = '${root.path}/Guide_Camera';
    await Directory(directoryPath).create(recursive: true);
    String filePath = '$directoryPath/${DateTime.now()}.jpg';
    try {
      await controller!.takePicture();
    } catch (e) {
      print(e);
    }
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initializeCamera(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height /
                              controller!.value.aspectRatio,
                          child: CameraPreview(controller!),
                        ),
                        Container(),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
