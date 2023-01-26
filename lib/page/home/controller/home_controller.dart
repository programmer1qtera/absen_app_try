import 'package:absen_try_app/page/login/view/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/user_model.dart';
// import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isKehadiran = false;

  late UserModel _userMember;
  UserModel get result => _userMember;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamHome() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore.collection('user').doc(uid).snapshots();
  }

  Future<void> signOut() async {
    await auth.signOut();
    Get.offAll(LoginView());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getKehadiran() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(uid)
        .collection('kehadiran')
        .orderBy('date')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getIzin() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore.collection('user').doc(uid).collection('cuti').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSakit(String idParam) async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParam)
        .collection('sakit')
        .snapshots();
  }

  void kehadiranPop() {
    isKehadiran = !isKehadiran;
    update();
  }
}
