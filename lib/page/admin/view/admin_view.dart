import 'package:absen_try_app/model/user_model.dart';
import 'package:absen_try_app/page/used_detail/view/user_detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/admin_ controler.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AdminController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        actions: [
          IconButton(
              onPressed: () {
                controller.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Daftar User Qtera',
              style: TextStyle(fontSize: 26),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // print(snapshot.data?.data());
                  if (snapshot.data?.docs.length == 0 ||
                      snapshot.data?.docs == null) {
                    return Center(
                      child: Text('Belum Ada Data Absen'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      UserModel userAllMod =
                          UserModel.fromDoc(snapshot.data!.docs[index]);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${userAllMod.name}'),
                              Text(
                                '${userAllMod.nip}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.yellowAccent),
                              ),
                              Text('${userAllMod.email}'),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text('Aktivitas Alamat :'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text('${userAllMod.address}')),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Get.to(UserDetail(
                                            userDetailMod: userAllMod));
                                      },
                                      child: Text('Lihat Detail User =>'))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
