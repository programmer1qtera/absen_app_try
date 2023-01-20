import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/state_manager.dart';

class IzinController extends GetxController {
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      print(fileName);
    } else {}
  }
}
