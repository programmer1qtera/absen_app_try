import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/user_model.dart';
// import 'package:intl/intl.dart';

class UserDetailController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isKehadiran = false;

  // late UserModel _userMember;
  // UserModel get result => _userMember;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamHome(
      String idParams) async* {
    yield* firestore.collection('user').doc(idParams).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getKehadiran(
      String idParams) async* {
    // String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParams)
        .collection('kehadiran')
        .orderBy('date')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getIzin(String idParams) async* {
    // String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParams)
        .collection('izin')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSakit(String idParams) async* {
    // String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParams)
        .collection('sakit')
        .snapshots();
  }

  void kehadiranPop() {
    isKehadiran = !isKehadiran;
    update();
  }
}
