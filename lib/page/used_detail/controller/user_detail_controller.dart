import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// import 'package:intl/intl.dart';

class UserDetailController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isKehadiran = false;
  bool isAprove = false;
  int? selectIndex;

  // late UserModel _userMember;
  // UserModel get result => _userMember;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamHome(
      String idParams) async* {
    yield* firestore.collection('user').doc(idParams).snapshots();
  }

  Future<void> aproved(String userId, String kehadiranId) async {
    await firestore
        .collection('user')
        .doc(userId)
        .collection('kehadiran')
        .doc(kehadiranId)
        .update({'isProve': 'Proved'});
    Get.back();
  }

  Future<void> notAproved(String userId, String kehadiranId) async {
    await firestore
        .collection('user')
        .doc(userId)
        .collection('kehadiran')
        .doc(kehadiranId)
        .update({'isProve': 'Not Proved'});
    Get.back();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getKehadiran(
      String idParams) async* {
    // String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParams)
        .collection('kehadiran')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getIzin(String idParams) async* {
    // String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParams)
        .collection('cuti')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSakit(String idParams) async* {
    // String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParams)
        .collection('sakit')
        .orderBy('date', descending: true)
        .snapshots();
  }

  void kehadiranPop() {
    isKehadiran = !isKehadiran;
    update();
  }

  void aprov(idx) {
    selectIndex = idx;
    print(selectIndex);
    selectIndex == idx ? isAprove = true : null;
    update();
  }
}
