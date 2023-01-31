import 'dart:convert';
import 'package:absen_try_app/model/keahdiran_model.dart';
import 'package:absen_try_app/services/kehadiran_services.dart';
import 'package:absen_try_app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
// import 'package:trust_location/trust_location.dart';

// import 'package:location_permissions/location_permissions.dart';
import 'package:flutter/services.dart';
import 'package:trust_location/trust_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/user_model.dart';

class TestController extends GetxController {
  @override
  void onInit() {
    getUser();
    getKehadiran();
    super.onInit();
  }

  String? latitude;
  String? longitude;
  bool isLoading = false;
  bool? isMockLocation;
  late UserModel userMod;
  UserModel get result => userMod;

  late List<KehadiranModel> kehadiranMod;
  List<KehadiranModel> get resultKehadiran => kehadiranMod;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserServices userSevice = UserServices();
  KehadiranServices kehadiranServices = KehadiranServices();

  Future<void> tryFakeGps() async {
    bool isMockLocation = await TrustLocation.isMockLocation;
    print(isMockLocation);
  }

  // void requestLocationPermission() async {
  //   PermissionStatus permission =
  //       await LocationPermissions().requestPermissions();
  //   print('permissions: $permission');
  // }
  // UserModel get result => _userMod;

  Future<void> getUser() async {
    try {
      isLoading = true;
      update();
      var dataUser = await userSevice.streamHome2();
      print(dataUser);
      if (dataUser == null) {
        isLoading = false;
        update();
        print('error');
      } else {
        userMod = dataUser;
        isLoading = false;
        update();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getKehadiran() async {
    try {
      isLoading = true;
      update();
      var dataKehadiran = await kehadiranServices.streamKehadiran();

      // print(dataKehadiran[0].address);
      if (dataKehadiran == null) {
        isLoading = false;
        update();
        print('error');
      } else {
        print(dataKehadiran.length);
        kehadiranMod = dataKehadiran;
        isLoading = false;
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
