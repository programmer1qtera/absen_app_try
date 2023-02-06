import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/user_model.dart';
import '../../../services/user_services.dart';
import '../../login/view/login_view.dart';

class AdminController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  late UserModel userMod;
  UserModel get result => userMod;
  UserServices userSevice = UserServices();

  Future<void> signOut() async {
    await auth.signOut();
    Get.offAll(LoginView());
  }

  void updeateNotif(String userModId) async {
    await firestore.collection('user').doc(userModId).update({
      'notif': false,
    });
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
