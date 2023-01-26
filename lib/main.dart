import 'package:absen_try_app/page/admin/view/admin_view.dart';
import 'package:absen_try_app/page/home/view/home.dart';
import 'package:absen_try_app/page/cuti/view/cuti_view.dart';
import 'package:absen_try_app/page/kehadiran/view/kehadiran.dart';
import 'package:absen_try_app/page/login/view/login_view.dart';
import 'package:absen_try_app/page/sakit/view/sakit_page.dart';
import 'package:absen_try_app/page/tidak_hadir/view/tidak_hadir_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: LoginView());
  }
}
