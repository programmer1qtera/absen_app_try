import 'package:absen_try_app/model/keahdiran_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KehadiranServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<KehadiranModel>> streamKehadiran() async {
    String uid = await auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> getFire = await firestore
        .collection('user')
        .doc(uid)
        .collection('kehadiran')
        .get();
    print(getFire.docs.length);
    // print(getFire.docs.length);
    final kehadiranData =
        getFire.docs.map((e) => KehadiranModel.fromDoc(e)).toList();

    // var getdata = getFire.data();
    // print(getdata);
    // final userData = getFire.docs.map((e) => UserModel.fromDoc(e)).single;
    // final userData =
    // print(userData);

    return kehadiranData;
  }
}
