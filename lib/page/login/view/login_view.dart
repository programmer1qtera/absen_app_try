import 'package:absen_try_app/page/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
                labelText: 'Email', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: controller.pwdC,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Password', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                controller.userLogin();
              },
              child: Text('Login'))
        ],
      ),
    );
  }
}
