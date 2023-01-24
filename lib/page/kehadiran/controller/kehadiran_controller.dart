import 'dart:io';
import 'package:absen_try_app/page/home/view/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KehadiranController extends GetxController {
  TextEditingController placeC = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  final storage = s.FirebaseStorage.instance;
  var finalImage;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isLoading = false;
  // String textImg = 'Tes iamsnnahhhs';
  var itemAbsenLog = ['Masuk', 'Keluar'];

  String? pilihan;

  void isPilihan(dynamic value) {
    pilihan = value;
    update();
  }

  // Future<File> drawTextOnImage() async {
  //   photo = await _picker.pickImage(source: ImageSource.camera);

  //   // var image = await photo.pickImage(source: ImageSource.camera);

  //   var decodeImg = img.decodeImage(File(photo!.path).readAsBytesSync());

  //   img.drawString(decodeImg!, DateTime.now().toString(), font: img.arial14);

  //   var encodeImage = img.encodeJpg(decodeImg, quality: 100);

  //   finalImage = File(photo!.path)..writeAsBytesSync(encodeImage);
  //   print(finalImage);
  //   // return finalImage;
  // }

  void picImage() async {
    Map<String, dynamic> dataResponse = await determinePosition();

    // Map<String, dynamic> dataResponse = await determinePosition();

    if (dataResponse['error'] != true) {
      Position position = dataResponse['position'];
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      print(placemarks);

      String addres =
          '${placemarks[0].thoroughfare}, ${placemarks[0].subLocality}';
      print(addres);
      photo =
          await _picker.pickImage(imageQuality: 50, source: ImageSource.camera);
      if (photo != null) {
        var decodeImg = img.decodeImage(File(photo!.path).readAsBytesSync());
        print(addres);
        img.drawString(
          decodeImg!,
          addres,
          font: img.arial48,
        );

        var encodeImage = img.encodeJpg(decodeImg);

        finalImage = File(photo!.path)..writeAsBytesSync(encodeImage);
      } else {
        print(photo?.name);
      }
    } else {
      Get.snackbar('Eror', dataResponse['message']);
    }

    update();
  }

  void isAbsen() async {
    isLoading = true;
    print('Absen');
    Map<String, dynamic> dataResponse = await determinePosition();

    if (pilihan == null) {
      Get.snackbar('Info', 'Silakan pilih kategori absen terlebih dahulu');
    } else {
      if (photo != null) {
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String addres =
              '${placemarks[0].thoroughfare}, ${placemarks[0].subLocality}';
          await updatePosition(position, addres);
          print('$addres');
          double jarak = Geolocator.distanceBetween(
              -6.1636573, 106.8922156, position.latitude, position.longitude);
          print(jarak);
          await present(position, addres, jarak);

          print('last ${position.latitude},${position.longitude}');
          Get.snackbar('Berhasi Masuk', 'Anda berhasil absen Masuk');

          isLoading = false;
        } else {
          Get.snackbar('Eror', dataResponse['message']);
          isLoading = false;
        }
      } else {
        Get.snackbar('Error', 'Foto terlebih dahulu');
        isLoading = false;
      }
    }

    update();
  }

  // Future<dynamic> uploadImageToStorage() async {
  //   String uid = await auth.currentUser!.uid;
  // }

  Future<dynamic> present(
      Position position, String addres, double jaralk) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colKehadiran =
        await firestore.collection('user').doc(uid).collection('kehadiran');
    String name = photo!.name;
    File file = File(photo!.path);

    // QuerySnapshot<Map<String, dynamic>> getKehadiran = await colKehadiran.get();

    DateTime now = DateTime.now();
    print(DateFormat.yMd().format(now));
    String getTodayID = DateFormat.yMd().format(now).replaceAll('/', '-');

    String statusLoc = 'Di Luar Qtera';

    if (jaralk <= 200) {
      statusLoc = 'Di Qtera';
    }

    await storage.ref('$name').putFile(finalImage);
    String urlImage = await storage.ref('$name').getDownloadURL();

    await colKehadiran.doc().set({
      'date': now.toIso8601String(),
      'lat': position.latitude,
      'long': position.longitude,
      'place': placeC.text,
      'address': addres,
      'image': urlImage,
      'status': pilihan
    });
    Get.snackbar('Berhasi Masuk', 'Anda berhasil absen Masuk');
    Get.to(HomeView());

    // print(getKehadiran.docs.length);

    // if (getKehadiran.docs.length == 0) {
    // await colKehadiran.doc(getTodayID).set({
    //   'date': now.toIso8601String(),
    //   'masuk': {
    //     'date': now.toIso8601String(),
    //     'lat': position.latitude,
    //     'long': position.longitude,
    //     'address': addres,
    //     'status': statusLoc
    //   },
    // });
    // Get.snackbar('Berhasi Masuk', 'Anda berhasil absen Masuk');
    // } else {
    //   DocumentSnapshot<Map<String, dynamic>> todayDoc =
    //       await colKehadiran.doc(getTodayID).get();

    //   if (todayDoc.exists == true) {
    //     Map<String, dynamic>? dataToday = todayDoc.data();
    //     if (dataToday?['keluar'] != null) {
    //       Get.snackbar('Info', 'Hari ini anda Telah absen Masuk dan Keluar');
    //     } else {
    //       await colKehadiran.doc(getTodayID).update({
    //         'keluar': {
    //           'date': now.toIso8601String(),
    //           'lat': position.latitude,
    //           'long': position.longitude,
    //           'address': addres,
    //           'status': statusLoc
    //         },
    //       });
    //       Get.snackbar('Berhasi Keluar', 'Anda berhasil absen Keluar');
    //     }
    //   } else {
    //     print('Kehadiran Masuk');
    //     await colKehadiran.doc(getTodayID).set({
    //       'date': now.toIso8601String(),
    //       'masuk': {
    //         'date': now.toIso8601String(),
    //         'lat': position.latitude,
    //         'long': position.longitude,
    //         'address': addres,
    //         'status': statusLoc
    //       },
    //     });
    //     Get.snackbar('Berhasi Masuk', 'Anda berhasil absen Masuk');
    //   }
    // }
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
