import 'package:absen_try_app/page/login/view/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserController extends GetxController {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerNip = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void userCreated() async {
    if (controllerName.text.isNotEmpty &&
        controllerEmail.text.isNotEmpty &&
        controllerNip.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: controllerEmail.text, password: 'u123456');

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          await firestore.collection('user').doc(uid).set({
            'name': controllerName.text,
            'email': controllerEmail.text,
            'nip': controllerNip.text,
            'create_at': DateTime.now().toIso8601String(),
            'role': 'user',
            'sisa_cuti': 12,
            'address': 'Not Update Yet'
          });
          Get.off(LoginView());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {}
    } else {
      Get.snackbar('Empty', 'All off field must require');
    }
  }
}
