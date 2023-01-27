import 'package:absen_try_app/model/keahdiran_model.dart';
import 'package:absen_try_app/model/user_model.dart';
import 'package:absen_try_app/page/used_detail/controller/user_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserKehadiranProve extends GetView<UserDetailController> {
  UserModel usrMod;
  KehadiranModel khdrMod;
  UserKehadiranProve({required this.usrMod, required this.khdrMod, super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(UserDetailController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 46, 46, 46),
              borderRadius: BorderRadius.circular(5)),
          height: 240,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.person_4_outlined),
                    InkWell(onTap: () => Get.back(), child: Icon(Icons.close))
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  '${usrMod.name} Prove Absen',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 6,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Absen : ${khdrMod.status}',
                    ),
                    Text(
                      'Tempat Kunjungan : ${khdrMod.place}',
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 130,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              controller.aproved(usrMod.id, khdrMod.id);
                            },
                            child: Text(
                              'Aprove',
                            ))),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 130,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFE7177)),
                            onPressed: () {
                              controller.notAproved(usrMod.id, khdrMod.id);
                            },
                            child: Text('Tidak Prove')))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
