import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneakerstore_client/pages/home_page.dart';
import 'package:sneakerstore_client/pages/login_page.dart';
import 'package:sneakerstore_client/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controller/login_controller.dart';
import 'firebaseOption.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  Get.put(LoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sneaker store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegisterPage(),
    );
  }
}


