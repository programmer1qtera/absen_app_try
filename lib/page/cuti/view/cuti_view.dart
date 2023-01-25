import 'package:absen_try_app/page/cuti/controller/cuti_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CutiView extends GetView<CutiController> {
  const CutiView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CutiController());
    controller.getDateTime = null;
    controller.fileName = null;
    controller.controllerDesc.text == '';
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GetBuilder<CutiController>(builder: (c) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Izin Cuti',
              style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(c.getDateTime == null
                    ? 'Pilih Tanggal Cuti'
                    : '${c.getDateTime}'),
                IconButton(
                    onPressed: () {
                      c.getCalender(context);
                    },
                    icon: Icon(Icons.calendar_today))
              ],
            ),
            Row(
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
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              maxLines: 5,
              controller: controller.controllerDesc,
              decoration: InputDecoration(
                  hintText: 'Keterangan Cuti', border: OutlineInputBorder()),
            ),
            ElevatedButton(
                onPressed: () {
                  if (controller.controllerDesc.text == null ||
                      controller.controllerDesc.text == '') {
                    Get.snackbar('Keterang Diisi', 'Keterangan harus diisi');
                  } else {
                    controller.keterlambatan();
                  }
                },
                child: Text('Cuti'))
          ],
        );
      }),
    );
  }
}
