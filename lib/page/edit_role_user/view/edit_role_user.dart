import 'package:absen_try_app/model/user_model.dart';
import 'package:absen_try_app/page/edit_role_user/controller/edit_role_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class EditRoleUserView extends GetView<EditRoleUserController> {
  UserModel userModel;
  EditRoleUserView({required this.userModel, super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(EditRoleUserController());
    controller.controlerRole.text = userModel.role!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Role User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${userModel.name}'),
            SizedBox(
              height: 10,
            ),
            Text(
              '${userModel.nip}',
              style: TextStyle(fontSize: 22, color: Colors.greenAccent),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: controller.controlerRole,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            ElevatedButton(
                onPressed: () {
                  controller.editUserRole(userModel.id);
                },
                child: Text('Update Role'))
          ],
        ),
      ),
    );
  }
}
