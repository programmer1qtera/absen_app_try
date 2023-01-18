import 'package:absen_try_app/page/profile/controller/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic>? user = snapshot.data!.data();
                return ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    Text('${user?['name']}'),
                    Text('${user?['nip']}'),
                    Text('${user?['email']}'),
                    Text('${user?['create_at']}')
                  ],
                );
              } else {
                return Center(
                  child: Text('tidak ada data'),
                );
              }
            }));
  }
}
