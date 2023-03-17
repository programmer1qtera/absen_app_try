import 'package:absen_try_app/page/sakit/controlller/sakit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SakitView extends GetView<SakitController> {
  const SakitView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SakitController());
    controller.fileNameSuratSakit = null;
    controller.getDateTime = null;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GetBuilder<SakitController>(builder: (c) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(
              height: 10,
            ),
            Text('Surat Sakitt', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    c.fileNameSuratSakit != null
                        ? '${c.fileNameSuratSakit}'
                        : 'file belum di pilih',
                    style: TextStyle(color: Colors.white38)),
                ElevatedButton(
                    onPressed: () {
                      c.pickFileSuratSakit();
                    },
                    child: Text('Pilih file')),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Copy Resep',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  c.fileNameCopyResep != null
                      ? '${c.fileNameCopyResep}'
                      : 'file belum di pilih',
                  style: TextStyle(color: Colors.white38),
                ),
                ElevatedButton(
                    onPressed: () {
                      c.pickFileCopyResep();
                    },
                    child: Text('Pilih file')),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Kuitansi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  c.fileNameKuitansi != null
                      ? '${c.fileNameKuitansi}'
                      : 'file belum di pilih',
                  style: TextStyle(color: Colors.white38),
                ),
                ElevatedButton(
                    onPressed: () {
                      c.pickFileKuitansi();
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
