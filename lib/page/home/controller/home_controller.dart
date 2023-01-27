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
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getIzin() async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(uid)
        .collection('cuti')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSakit(String idParam) async* {
    String uid = await auth.currentUser!.uid;
    yield* firestore
        .collection('user')
        .doc(idParam)
        .collection('sakit')
        .orderBy('date', descending: true)
        .snapshots();
  }

  void kehadiranPop() {
    isKehadiran = !isKehadiran;
    update();
  }

  Future<dynamic> getCuti() async {
    //implemen add cuti otomatic
    DateTime now = DateTime.now();
    String uid = auth.currentUser!.uid;
    var collectionUser = await firestore.collection('user').doc(uid).get();
    var getCutiFirebase = collectionUser.data()!['sisa_cuti'];
    int sisaCuti = 12;
    print(now.month);
    if (now.month == 1 && now.day == 1) {
      print('Tahun Baru');
      getCutiFirebase += 12;
      print(getCutiFirebase);
    } else {
      print('Belum tahun baru');
    }
    //implement  cuti pengurangan by user
    // String uid = auth.currentUser!.uid;
    // var collectionUser = await firestore.collection('user').doc(uid).get();
    // // return UserModel.fromDoc(collectionUser);
    // var collectionKehadiran =
    //     await firestore.collection('user').doc(uid).collection('cuti').get();

    // // print(userCredential);
    // var getRole = collectionUser.data()!['sisa_cuti'];
    // var getLengtCuti = collectionKehadiran.docs.length;
    // var countCuti = getRole - getLengtCuti;
    // print(getRole);
    // print(getLengtCuti);
    // print(countCuti);
  }
}
