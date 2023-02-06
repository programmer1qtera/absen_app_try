import 'package:absen_try_app/page/create_user/controller/create_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class CreateUserView extends GetView<CreateUserController> {
  const CreateUserView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CreateUserController());
    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: controller.controllerName,
              decoration: InputDecoration(
                  hintText: 'Name', border: OutlineInputBorder()),
            ),
            TextField(
              controller: controller.controllerEmail,
              decoration: InputDecoration(
                  hintText: 'Email', border: OutlineInputBorder()),
            ),
            TextField(
              controller: controller.controllerNip,
              decoration: InputDecoration(
                  hintText: 'Nip', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  controller.userCreated();
                },
                child: Text('Created'))
          ],
        ),
      ),
    );
  }
}
