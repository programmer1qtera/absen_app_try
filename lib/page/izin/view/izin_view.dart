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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                controller.pickFile();
              },
              child: Text('Pilih file')),
          SizedBox(
            height: 30,
          ),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
                hintText: 'Keterangan izi', border: OutlineInputBorder()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.present_to_all),
      ),
    );
  }
}
