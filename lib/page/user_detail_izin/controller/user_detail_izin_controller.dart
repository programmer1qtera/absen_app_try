import 'package:absen_try_app/model/izin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserDetailIzinController extends GetxController {
  // bool isProved = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void aprove(bool? isProve, String userDocId, String cutiId) {
    isProve = !isProve!;
    print(isProve);
    update();
    updateProved(isProve, userDocId, cutiId);
  }

  Future<dynamic> updateProved(
      bool isProv, String userDocIdProve, String cutiIdProve) async {
    // String uid = await auth.currentUser!.uid;
    await firestore
        .collection('user')
        .doc(userDocIdProve)
        .collection('cuti')
        .doc(cutiIdProve)
        .update({'proved': isProv});
    Get.back();
  }
}
