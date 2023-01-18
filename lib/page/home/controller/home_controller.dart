import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamHome() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore.collection('user').doc(uid).snapshots();
  }

  void isAbsen() async {
    print('Absen');
    Map<String, dynamic> dataResponse = await determinePosition();
    if (dataResponse['error'] != true) {
      Position position = dataResponse['position'];
      print('${position.latitude}${position.longitude}');
      List<Placemark> placemarks =
          await placemarkFromCoordinates(-6.427282728508096, 106.8020050580458);

      print(placemarks);
      Get.snackbar('Berhasi', dataResponse['message']);
    } else {
      Get.snackbar('Eror', dataResponse['message']);
    }
    // await updatePosition(position);
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

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.

  Future<dynamic> updatePosition(Position position) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection('user').doc(uid).update({
      'position': {'lat': position.latitude, 'long': position.longitude}
    });
  }
}
