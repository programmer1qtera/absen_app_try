import 'dart:io';

import 'package:absen_try_app/page/home/view/home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:intl/intl.dart';

class SakitController extends GetxController {
  TextEditingController controllerDesc = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = s.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? getDateTime;
  File? fileSuratSakit;
  String? fileNameSuratSakit;

  File? fileCopyResep;
  String? fileNameCopyResep;

  File? fileKuitansi;
  String? fileNameKuitansi;

  void pickFileSuratSakit() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fileSuratSakit = File(result.files.single.path!);
      fileNameSuratSakit = result.files.single.name;
      print(fileNameSuratSakit);
      update();
    } else {
      print('error');
    }
  }

  void pickFileCopyResep() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fileCopyResep = File(result.files.single.path!);
      fileNameCopyResep = result.files.single.name;
      print(fileNameCopyResep);
      update();
    } else {
      print('error');
    }
  }

  void pickFileKuitansi() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fileKuitansi = File(result.files.single.path!);
      fileNameKuitansi = result.files.single.name;
      print(fileNameKuitansi);
      update();
    } else {
      print('error');
    }
  }

  void getCalender(context) async {
    var date = DateTime.now();
    final rangeDate = DateTime(date.year, date.month, date.day - 2);

    DateTime? getNewDate = await showDatePicker(
        helpText: 'Qtera Calender ',
        context: context,
        initialDate: DateTime.now(),
        firstDate: rangeDate,
        lastDate: DateTime.now());

    if (getNewDate != null) {
      String getDay = DateFormat.EEEE().format(getNewDate);
      if (getDay == 'Saturday' || getDay == 'Sunday') {
        if (getDay == 'Saturday') {
          String indDaya = 'Sabtu';
          Get.snackbar(
              'Hari Libur', 'Anda yakin izin sakit di hari $indDaya ?');
        } else {
          String indDaya = 'Minggu';
          Get.snackbar(
              'Hari Libur', 'Anda yakin izin sakit di hari $indDaya ?');
        }
        getDateTime = null;
        getNewDate = null;
        update();
      } else {
        getDateTime = DateFormat.yMMMMEEEEd().format(getNewDate);
        update();
      }
    } else {
      getDateTime = null;
      getNewDate = null;
      update();
    }

    //     .then((value) {
    //   dateTime = value;
    //   dateTime == null
    //       ? null
    //       : getDateTime = DateFormat.yMd().format(dateTime!);

    //   update();
    // });
  }

  void isSakit() async {
    print('Sakit');
    Map<String, dynamic> dataResponse = await determinePosition();
    if (getDateTime != null) {
      if (fileSuratSakit != null) {
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String addres =
              '${placemarks[0].thoroughfare}, ${placemarks[0].subLocality}';
          await updatePosition(position, addres);
          print('$addres');
          // double jarak = Geolocator.distanceBetween(
          //     -6.1636573, 106.8922156, position.latitude, position.longitude);
          // print(jarak);
          await present(position, addres);

          print('${position.latitude},${position.longitude}');
        } else {
          Get.snackbar('Eror', dataResponse['message']);
        }
      } else {
        Get.snackbar('Error', 'file belum di upload');
      }
    } else {
      Get.snackbar('Tanggal Diisi', 'Tanggal Harus Di isi');
    }

    update();
  }

  Future<dynamic> present(Position position, String addres) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colKehadiran =
        await firestore.collection('user').doc(uid).collection('sakit');

    // QuerySnapshot<Map<String, dynamic>> getKehadiran = await colKehadiran.get();

    DateTime now = DateTime.now();
    print(DateFormat.yMd().format(now));
    // String getTodayID = DateFormat.yMd().format(now).replaceAll('/', '-');

    // String statusLoc = 'Di Luar Qtera';

    // if (jaralk <= 200) {
    //   statusLoc = 'Di Qtera';
    // }

    // await storage.ref('$fileName').putFile(file!);
    // String filePDF = await storage.ref('$fileName').getDownloadURL();

    await colKehadiran.doc().set({
      'satus': 'sakit',
      'date': now.toIso8601String(),
      'lat': position.latitude,
      'long': position.longitude,
      'tanggal_pengajuan_sakit': getDateTime,
      'description': controllerDesc.text,
      'address': addres,
      'nameFile': {
        'surat_sakit': fileNameSuratSakit,
        'copy_resep': fileNameCopyResep,
        'kuitansi': fileNameKuitansi
      },
      // 'file': filePDF,
    });
    Get.snackbar('Izin Berhasil', 'Anda berhasil Izin');
    Get.to(HomeView());
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        'message': 'Tidak di dapat untuk mengambil GPS dari devaces ini',
        'error': true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          'message': 'Izin di tolak',
          'error': true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        'message': 'Tidak di izinkam untuk mangakses gps',
        'error': true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      'position': position,
      'message': 'berhasil mendapatkan posisi',
      'error': false,
    };
  }

  Future<dynamic> updatePosition(Position position, String addres) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection('user').doc(uid).update({
      'position': {
        'lat': position.latitude,
        'long': position.longitude,
      },
      'address': addres
    });
  }
}
