import 'package:absen_try_app/model/izin_model.dart';
import 'package:absen_try_app/model/keahdiran_model.dart';
import 'package:absen_try_app/model/user_model.dart';
import 'package:absen_try_app/page/home/controller/home_controller.dart';
import 'package:absen_try_app/page/cuti/view/cuti_view.dart';
import 'package:absen_try_app/page/kehadiran/view/kehadiran.dart';
import 'package:absen_try_app/page/profile/view/profile_view.dart';
import 'package:absen_try_app/page/tidak_hadir/view/tidak_hadir_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../maps/maps_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ProfileView());
              },
              icon: Icon(Icons.person)),
          IconButton(
              onPressed: () {
                controller.signOut();
              },
              icon: Icon(Icons.logout))
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
              UserModel userMod = UserModel.fromDoc(snapshot.data!);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'welcome',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(userMod.address != null
                              ? '${userMod.address}'
                              : 'Lokasi tidak di temukan'),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${userMod.name}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${userMod.nip}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.amberAccent),
                                  ),
                                  Text('${userMod.email}')
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(KehadiranView());
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blueAccent,
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Absen')
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(TidakHadirView());
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.greenAccent,
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Tidak Hadir')
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GetBuilder<HomeController>(builder: (c) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Kehadiran'),
                                TextButton(
                                    onPressed: () {
                                      c.kehadiranPop();
                                    },
                                    child: Icon(Icons.arrow_drop_down_circle))
                              ],
                            ),
                            c.isKehadiran == false
                                ? SizedBox(
                                    height: 10,
                                  )
                                : StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    stream: controller.getKehadiran(),
                                    builder: (context, snapshotP) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      // print(snapshotP.data?.data());
                                      if (snapshotP.data?.docs.length == 0 ||
                                          snapshotP.data?.docs == null) {
                                        return Center(
                                          child: Text('Belum Ada Data Absen'),
                                        );
                                      }

                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshotP.data?.docs.length,
                                        itemBuilder: (context, index) {
                                          var data = snapshotP.data!.docs[index]
                                              .data();
                                          KehadiranModel kehadiranModel =
                                              KehadiranModel.fromDoc(
                                                  snapshotP.data!.docs[index]);

                                          // var getDataItem = snapshot.data?.data();
                                          return Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 100,
                                                      width: double.infinity,
                                                      child:
                                                          //  Center(
                                                          //   child: Text(
                                                          //       'Limit Firebase load image'),
                                                          // ),
                                                          Image.network(
                                                        data['image'],
                                                        fit: BoxFit.cover,
                                                      )),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        data['status'] == null
                                                            ? '-'
                                                            : '${data['status']}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: data['status'] ==
                                                                    'Masuk'
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .redAccent,
                                                            fontSize: 18),
                                                      ),
                                                      Text(kehadiranModel
                                                                  .status ==
                                                              'Masuk'
                                                          ? 'in : ${kehadiranModel.inn}'
                                                          : 'out : ${kehadiranModel.out}')
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    '${kehadiranModel.place}',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                      '${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}'),
                                                  Text('${data['address']}'),

                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  kehadiranModel
                                                              .statusKeterlambatan !=
                                                          null
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'Status : ${data['satus_keterlambatan']}'),
                                                            Text(
                                                                'Jangka waktu Keterlambatan : ${kehadiranModel.lamaKeterlambatan}')
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          height: 5,
                                                        ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      MapsView(
                                                                data: data,
                                                              ),
                                                            );
                                                          },
                                                          child: Icon(Icons
                                                              .location_history)),
                                                    ],
                                                  )

                                                  // Text('Keluar'),
                                                  // Text(data['keluar'] == null
                                                  //     ? '-'
                                                  //     : '${DateFormat.yMMMEd().add_Hms().format(DateTime.parse(data['keluar']['date']))}'),
                                                  // Text(data['keluar'] == null
                                                  //     ? '-'
                                                  //     : '${data['keluar']['address']}'),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                          ],
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cuti'),
                          TextButton(
                              onPressed: () {}, child: Text('See more ->'))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.getIzin(),
                          builder: (context, snapshotI) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshotI.data?.docs.length == 0 ||
                                snapshotI.data?.docs == null) {
                              return Center(
                                child: Text('Belum Ada Data Izin'),
                              );
                            }

                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshotI.data?.docs.length,
                              itemBuilder: (context, index) {
                                var dataIzin =
                                    snapshotI.data!.docs[index].data();
                                // var getDataItem = snapshot.data?.data();
                                IzinModel izinModel = IzinModel.fromDoc(
                                    snapshotI.data!.docs[index]);
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              color: izinModel.proved == true
                                                  ? Colors.green
                                                  : Colors.grey,
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                  izinModel.proved == true
                                                      ? 'Aproved'
                                                      : 'Waiting'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Cuti',
                                              // ${DateFormat('EEEEE').format(DateTime.parse(dataIzin['date']))}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.yellowAccent,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              dataIzin['date'] == null
                                                  ? '-'
                                                  : '${DateFormat.Hms().format(DateTime.parse(dataIzin['date']))}',
                                              style: TextStyle(
                                                  color: Colors.grey[300]),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          '${DateFormat.yMMMEd().format(DateTime.parse(dataIzin['date']))}',
                                          style: TextStyle(
                                              color: Colors.grey[300]),
                                        ),
                                        Text(
                                          '${dataIzin['address']}',
                                          style: TextStyle(
                                              color: Colors.grey[300]),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Tgl Pengajuan Cuti : ${dataIzin['tanggal_cuti']}'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('${dataIzin['description']}'),
                                        Row(
                                          children: [
                                            Icon(Icons.file_present),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('${dataIzin['nameFile']}')
                                          ],
                                        )
                                        // Text('Keluar'),
                                        // Text(data['keluar'] == null
                                        //     ? '-'
                                        //     : '${DateFormat.yMMMEd().add_Hms().format(DateTime.parse(data['keluar']['date']))}'),
                                        // Text(data['keluar'] == null
                                        //     ? '-'
                                        //     : '${data['keluar']['address']}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sakit'),
                          TextButton(
                              onPressed: () {}, child: Text('See more ->'))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.getSakit(userMod.id),
                          builder: (context, snapshotI) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshotI.data?.docs.length == 0 ||
                                snapshotI.data?.docs == null) {
                              return Center(
                                child: Text('Belum Ada Data Sakit'),
                              );
                            }

                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshotI.data?.docs.length,
                              itemBuilder: (context, index) {
                                var dataIzin =
                                    snapshotI.data!.docs[index].data();
                                // var getDataItem = snapshot.data?.data();
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Sakit',
                                              // ${DateFormat('EEEEE').format(DateTime.parse(dataIzin['date']))}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.redAccent,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              dataIzin['date'] == null
                                                  ? '-'
                                                  : '${DateFormat.Hms().format(DateTime.parse(dataIzin['date']))}',
                                            ),
                                          ],
                                        ),

                                        Text(
                                          '${DateFormat.yMMMEd().format(DateTime.parse(dataIzin['date']))}',
                                          style: TextStyle(
                                              color: Colors.grey[400]),
                                        ),

                                        Text(
                                          '${dataIzin['address']}',
                                          style: TextStyle(
                                              color: Colors.grey[400]),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            'Tgl Pengajuan sakit : ${dataIzin['tanggal_pengajuan_sakit']}'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('${dataIzin['description']}'),
                                        Row(
                                          children: [
                                            Icon(Icons.file_present),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('${dataIzin['nameFile']}')
                                          ],
                                        )
                                        // Text('Keluar'),
                                        // Text(data['keluar'] == null
                                        //     ? '-'
                                        //     : '${DateFormat.yMMMEd().add_Hms().format(DateTime.parse(data['keluar']['date']))}'),
                                        // Text(data['keluar'] == null
                                        //     ? '-'
                                        //     : '${data['keluar']['address']}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
              );
            } else {
              return Text('Tidak Ada data');
            }
          }),
    );
  }
}
