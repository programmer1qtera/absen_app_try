import 'package:absen_try_app/page/izin/controller/izin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IzinView extends GetView<IzinController> {
  const IzinView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(IzinController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Izin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<IzinController>(
              builder: (c) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(c.fileName != null? '${c.fileName}':'file belum di pilih' ),
                    ElevatedButton(
                        onPressed: () {
                          c.pickFile();
                        },
                        child: Text('Pilih file')),
                  ],
                );
              }
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              maxLines: 5,
              controller: controller.controllerDesc,
              decoration: InputDecoration(
                  hintText: 'Keterangan izi', border: OutlineInputBorder()),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.isIzin();
        },
        child: Icon(Icons.present_to_all),
      ),
    );
  }
}
