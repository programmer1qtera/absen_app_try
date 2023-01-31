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

class CutiController extends GetxController {
  TextEditingController controllerDesc = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = s.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? getDateTime;
  int? countCuti;
  // DateTime now = DateTime.now();

  File? file;
  String? fileName;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      fileName = result.files.single.name;
      print(fileName);
      update();
    } else {
      print('error');
    }
  }

  void isIzin() async {
    print('Cuti');
    Map<String, dynamic> dataResponse = await determinePosition();
    if (getDateTime == null) {
      Get.snackbar('Tanggal Kosong', 'Tanggal harus di isi');
    } else {
      if (file != null) {
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String addres =
              '${placemarks[0].thoroughfare}, ${placemarks[0].subLocality}';

          print('$addres');
          // double jarak = Geolocator.distanceBetween(
          //     -6.1636573, 106.8922156, position.latitude, position.longitude);
          // print(jarak);
          await present(position, addres);
          await getCuti();
          await updatePosition(position, addres);
          print('${position.latitude},${position.longitude}');
        } else {
          Get.snackbar('Eror', dataResponse['message']);
        }
      } else {
        Get.snackbar('Error', 'file belum di upload');
      }
    }

    update();
  }

  Future<dynamic> present(Position position, String addres) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colKehadiran =
        await firestore.collection('user').doc(uid).collection('cuti');

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
      'satus': 'cuti',
      'date': now.toIso8601String(),
      'lat': position.latitude,
      'long': position.longitude,
      'description': controllerDesc.text,
      'tanggal_cuti': getDateTime,
      'proved': false,
      'address': addres,
      'nameFile': fileName,
      // 'file': filePDF,
    });
    Get.snackbar('Izin Berhasil', 'Anda berhasil Izin');
    Get.to(HomeView());
  }

  Future<dynamic> getCuti() async {
    String uid = auth.currentUser!.uid;
    var collectionUser = await firestore.collection('user').doc(uid).get();
    // return UserModel.fromDoc(collectionUser);
    // var collectionKehadiran =
    //     await firestore.collection(b'user').doc(uid).collection('cuti').get();

    // print(userCredential);
    int getRole = collectionUser.data()!['sisa_cuti'];
    // int getLengtCuti = collectionKehadiran.docs.length;
    countCuti = getRole - 1;
    print(getRole);
    // print(getLengtCuti);
    print(countCuti);
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
      'address': addres,
      'sisa_cuti': countCuti
    });
  }

  void getCalender(context) async {
    // TimeOfDay now = TimeOfDay.now();
    // const TimeOfDay releaseTime = TimeOfDay(hour: 15, minute: 0); // 3:00pm
    // TimeOfDay roomBooked =
    //     TimeOfDay.fromDateTime(DateTime.parse('2018-10-20 16:30:04Z'));
    // print(releaseTime);
    // print(roomBooked);
    DateTime date = DateTime.now();

    DateTime firstDayPic = DateTime(date.year, date.month, date.day + 6);
    DateTime? newDate = await showDatePicker(
        helpText: 'Qtera Calender ',
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        // selectableDayPredicate: ,
        initialDate: DateTime.now(),
        firstDate: date,
        lastDate: firstDayPic);
    if (newDate != null) {
      //  dateTime = newDate;
      String timeDay = DateFormat.EEEE().format(newDate);
      print(timeDay);
      if (timeDay == 'Saturday' || timeDay == 'Sunday') {
        if (timeDay == 'Saturday') {
          String indDaya = 'Sabtu';
          Get.snackbar('Hari Libur', 'Anda yakin cuti di hari $indDaya ?');
        } else {
          String indDaya = 'Minggu';
          Get.snackbar('Hari Libur', 'Anda yakin cuti di hari $indDaya ?');
        }
        newDate = null;
        getDateTime = null;
        update();
      } else {
        print(newDate);
        getDateTime = DateFormat.yMMMMEEEEd().format(newDate);
        update();
      }
    } else {
      newDate = null;
      getDateTime = null;
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

  void keterlambatan() {
    // TimeOfDay now = TimeOfDay.now();
    // TimeOfDay releaseTime = TimeOfDay(hour: 08, minute: 30);

    DateTime dateNow = DateTime.now();
    DateTime batasWaktu =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 08, 30);
    print('batas waktu: $batasWaktu');
    if (dateNow.hour > batasWaktu.hour) {
      DateTime rangeTime = DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day,
          dateNow.hour > 08 ? dateNow.hour - 08 : 08 - dateNow.hour,
          dateNow.minute > 08 ? dateNow.minute - 30 : 30 - dateNow.minute);
      print(' Lama keterlambatan ${DateFormat.Hm().format(rangeTime)}');
      print('Terlambat');
    } else {
      print('tidak terlambat');
    }

    // print(now);
    // print(releaseTime);

    // if (now.hour > releaseTime.hour) {
    //   TimeOfDay rangeKeterlambatan = TimeOfDay(
    //       hour: now.hour - 08,
    //       minute: now.minute > 30 ? now.minute - 30 : 30 - now.minute);
    //   print(' Lama keterlambatan $rangeKeterlambatan');
    //   print('Terlambat');
    // } else {
    //   print('tidak terlambat');
    // }
    //   int daysBetween(TimeOfDay from, TimeOfDay to) {
    //    from = TimeOfDay( hour: from.hour,minute: from.minute,);
    //    to = TimeOfDay(hour: to.hour, minute: to.hour);
    //  return (to.difference(from).inHours / 24).round();
    // }
    //  final difference = daysBetween(now, releaseTime);
  }
}
