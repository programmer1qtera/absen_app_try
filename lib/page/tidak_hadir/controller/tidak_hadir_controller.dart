import 'package:get/get.dart';

class TidakHadirController extends GetxController {
  var itemAbsenLog = ['Izin Sakit', 'Cuti'];
  bool? isSakit;

  String? pilihan;

  void isPilihan(dynamic value) {
    pilihan = value;
    if (pilihan == 'Izin Sakit') {
      isSakit = true;
    } else {
      isSakit = false;
      print('Cuti');
    }
    update();
  }
}
