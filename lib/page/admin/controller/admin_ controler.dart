import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../login/view/login_view.dart';

class AdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await auth.signOut();
    Get.offAll(LoginView());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() async* {
    // String uid = auth.currentUser!.uid;
    // var collectionUser = await firestore.collection('user').doc().get();
    // // print(userCredential);
    // var getRole = collectionUser.data()!['role'];
    yield* firestore
        .collection('user')
        .where('role', isEqualTo: 'user')
        .snapshots();
  }
}
