import 'package:absen_try_app/page/admin/view/admin_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditRoleUserController extends GetxController {
  TextEditingController controlerRole = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void editUserRole(String id) async {
    if (controlerRole.text.isNotEmpty) {
      try {
        await firestore.collection('user').doc(id).update({
          'role': controlerRole.text,
        });
        Get.off(AdminView());
      } catch (e) {
        throw Exception(e);
      }
    } else {
      Get.snackbar('Empty', 'Role tidak boleh kosong');
    }
  }
}
