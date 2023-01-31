import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class UserServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<UserModel> streamHome2() async {
    String uid = await auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> getFire =
        await firestore.collection('user').doc(uid).get();
    // var getdata = getFire.data();
    // print(getdata);
    // final userData = getFire.docs.map((e) => UserModel.fromDoc(e)).single;
    // final userData =
    // print(userData);

    return UserModel.fromDoc(getFire);
  }
}
