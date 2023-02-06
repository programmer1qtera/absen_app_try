import 'package:absen_try_app/page/create_user/view/create_user_view.dart';
import 'package:absen_try_app/page/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
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
          GetBuilder<LoginController>(builder: (c) {
            return ElevatedButton(
                onPressed: () {
                  if (c.isLoading == false) {
                    controller.userLogin();
                  } else {
                    Get.snackbar('Tunggu', 'Sedang proses login');
                  }
                },
                child: c.isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text('Login'));
          }),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () => Get.to(CreateUserView()),
              child: Text('Not Have Acount ?'))
        ],
      ),
    );
  }
}
