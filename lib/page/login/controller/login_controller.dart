import 'package:absen_try_app/page/admin/view/admin_view.dart';
import 'package:absen_try_app/page/home/view/home.dart';
import 'package:absen_try_app/page/home/view/test_model.dart';
import 'package:absen_try_app/page/kehadiran/view/kehadiran.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController(text: 'user2@gmail.com');
  TextEditingController pwdC = TextEditingController(text: 'u123456');

  // TextEditingController emailC = TextEditingController(text: 'admin@gmail.com');
  // TextEditingController pwdC = TextEditingController(text: 'a123456');

  FirebaseAuth auth = FirebaseAuth.instance;

  void userLogin() async {
    if (emailC.text.isNotEmpty || pwdC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: pwdC.text);
        // print(userCredential);
        String uid = await auth.currentUser!.uid;
        if (uid == '7jWjgvRnXQVe3jqJO7YRga2T2Wr2') {
          Get.off(AdminView());
        } else {
          Get.off(HomeView());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email');
          Get.snackbar('User Not found', 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          Get.snackbar('Password Salah', 'Password Salah.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('Email password kosong');
      Get.snackbar('Error', 'Email password kosong');
    }
  }
}
