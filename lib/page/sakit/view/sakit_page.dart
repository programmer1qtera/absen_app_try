import 'package:absen_try_app/page/sakit/controlller/sakit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SakitView extends GetView<SakitController> {
  const SakitView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SakitController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Sakit'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<SakitController>(builder: (c) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(c.fileName != null
                      ? '${c.fileName}'
                      : 'file belum di pilih'),
                  ElevatedButton(
                      onPressed: () {
                        c.pickFile();
                      },
                      child: Text('Pilih file')),
                ],
              );
            }),
            SizedBox(
              height: 30,
            ),
            TextField(
              maxLines: 5,
              controller: controller.controllerDesc,
              decoration: InputDecoration(
                  hintText: 'Keterangan sakit', border: OutlineInputBorder()),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.isSakit();
        },
        child: Icon(Icons.present_to_all),
      ),
    );
  }
}
