import 'package:absen_try_app/page/home/controller/home_controller.dart';
import 'package:absen_try_app/page/profile/view/profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ProfileView());
              },
              icon: Icon(Icons.person))
          // StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          //   stream: controller.streamHome(),
          //   builder: (context, snapshot) {
          //     return IconButton(
          //         onPressed: () {
          //           Get.to(ProfileView());
          //         },
          //         icon: Icon(Icons.person));
          //   }
          // )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamHome(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data!.data();
              return ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(user?['position'] != null
                          ? '${user?['position']['lat']}'
                          : 'Jl Raya Bogor'),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${user?['name']}'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${user?['nip']}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text('${user?['email']}')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [Text('Masuk'), Text('-')],
                          ),
                          Column(
                            children: [Text('Keluar'), Text('-')],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Masuk'),
                          Text('${DateTime.now()}'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Keluar'),
                          Text('${DateTime.now()}'),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      );
                    },
                  )
                ],
              );
            } else {
              return Text('Tidak Ada data');
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.isAbsen();
        },
        child: Icon(Icons.person),
      ),
    );
  }
}
