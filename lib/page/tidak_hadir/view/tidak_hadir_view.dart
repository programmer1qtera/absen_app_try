import 'package:absen_try_app/page/cuti/view/cuti_view.dart';
import 'package:absen_try_app/page/sakit/view/sakit_page.dart';
import 'package:absen_try_app/page/tidak_hadir/controller/tidak_hadir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TidakHadirView extends GetView<TidakHadirController> {
  const TidakHadirView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TidakHadirController());
    return Scaffold(
        appBar: AppBar(
          title: Text('Tidak Hadir'),
        ),
        body: GetBuilder<TidakHadirController>(builder: (c2) {
          return ListView(children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    c2.pilihan == null ? 'Pilih Absen' : '${c2.pilihan}',
                    style: TextStyle(
                        color: c2.pilihan == null
                            ? Colors.white
                            : c2.pilihan == 'Izin Sakit'
                                ? Colors.redAccent
                                : Colors.yellowAccent),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      controller.isPilihan(value);
                    },
                    itemBuilder: (context) {
                      return controller.itemAbsenLog
                          .map<PopupMenuItem>((String e) =>
                              PopupMenuItem(value: e, child: Text(e)))
                          .toList();
                    },
                  )
                ],
              ),
            ),
            controller.isSakit == null
                ? Center(child: Text('Pilih alasan tidak Masuk'))
                : controller.isSakit == true
                    ? SakitView()
                    : CutiView()
          ]);
        }));
  }
}
