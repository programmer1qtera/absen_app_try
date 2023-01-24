import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/user_model.dart';

class TestController extends GetxController {
  @override
  void onReady() {
    getUser();
    super.onReady();
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  UserModel? userMod;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // UserModel get result => _userMod;

  Future<dynamic> getUser() async {
    try {
      var dataUser = await streamHome2();
      print(dataUser);
      if (dataUser != null) {
        userMod = dataUser;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel> streamHome2() async {
    String uid = await auth.currentUser!.uid;
    var getFire = await firestore.collection('user').doc(uid).get();
    // final userData = getFire.docs.map((e) => UserModel.fromDoc(e)).single;
    // final userData =
    // print(userData);

    return UserModel.fromDoc(getFire);
  }
}
