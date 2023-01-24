import 'package:absen_try_app/page/home/controller/tes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class TestModel extends GetView<TestController> {
  TestModel({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TestController());
    return Scaffold(
      body: Center(
        child: Text('${controller.userMod?.name}'),
      ),
    );
  }
}
