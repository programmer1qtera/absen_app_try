import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/kehadiran_controller.dart';

class KehadiranView extends GetView<KehadiranController> {
  const KehadiranView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(KehadiranController());

    return Scaffold(
        appBar: AppBar(
          title: Text('Kehadiran'),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              GetBuilder<KehadiranController>(builder: (c2) {
                return Row(
                  children: [
                    Text(c2.pilihan == null ? 'Pilih Absen' : '${c2.pilihan}'),
                    PopupMenuButton(
                      icon: Icon(Icons.arrow_drop_down),
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
                );
              }),
              SizedBox(
                height: 20,
              ),
              GetBuilder<KehadiranController>(builder: (c) {
                if (c.photo != null) {
                  return c.isLoading == true
                      ? CircularProgressIndicator()
                      : Image.file(File(c.photo!.path));
                } else {
                  return Container(height: 250, color: Colors.grey[800]);
                }
              }),
              ElevatedButton(
                onPressed: () {
                  controller.picImage();
                },
                child: Text('Ambil Gambar'),
              ),
              TextField(
                controller: controller.placeC,
                decoration: InputDecoration(
                    hintText: 'Tepat Absen', border: OutlineInputBorder()),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.isAbsen();
                },
                child: Text('Absen Sekarang'),
              ),
            ],
          ),
        ));
  }
}
