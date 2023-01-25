import 'package:absen_try_app/page/sakit/controlller/sakit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SakitView extends GetView<SakitController> {
  const SakitView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SakitController());
    controller.fileName = null;
    controller.getDateTime = null;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GetBuilder<SakitController>(builder: (c) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Izin Sakit',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(c.getDateTime == null ? 'Date time' : '${c.getDateTime}'),
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
                  hintText: 'Keterangan sakit', border: OutlineInputBorder()),
            ),
            ElevatedButton(
                onPressed: () {
                  if (controller.controllerDesc.text == '') {
                    Get.snackbar('Keterangan Diisi', 'Keterangan harus di isi');
                  } else {
                    controller.isSakit();
                  }
                },
                child: Text('Sakit'))
          ],
        );
      }),
    );
  }
}
