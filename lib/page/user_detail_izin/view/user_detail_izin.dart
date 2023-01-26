import 'package:absen_try_app/model/user_model.dart';
import 'package:absen_try_app/page/user_detail_izin/controller/user_detail_izin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/izin_model.dart';

class UserDetailIzin extends GetView<UserDetailIzinController> {
  IzinModel izinMod;
  UserModel userModel;
  UserDetailIzin({required this.izinMod, required this.userModel, super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(UserDetailIzinController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Izin'),
      ),
      body: Center(
        child: Container(
          height: 230,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<UserDetailIzinController>(builder: (c) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            // c.aprove(isProve, provedFromFire, userDocId, cutiId)
                            c.aprove(izinMod.proved, userModel.id, izinMod.id);
                          },
                          child: Container(
                            color: izinMod.proved == true
                                ? Colors.green
                                : Colors.grey,
                            padding: EdgeInsets.all(8),
                            child: Text('Aproved'),
                          ),
                        )
                      ],
                    );
                  }),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        izinMod.date == null
                            ? '-'
                            : '${DateFormat.Hms().format(DateTime.parse('${izinMod.date}'))}',
                      ),
                    ],
                  ),

                  Text(
                    '${DateFormat.yMMMEd().format(DateTime.parse('${izinMod.date}'))}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    '${izinMod.address}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Tgl Pengajuan Cuti : ${izinMod.tanggalCuti}'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${izinMod.description}'),
                  Row(
                    children: [
                      Icon(Icons.file_present),
                      SizedBox(
                        width: 10,
                      ),
                      Text('${izinMod.nameFile}')
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
          ),
        ),
      ),
    );
  }
}
