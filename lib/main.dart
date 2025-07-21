import 'package:apple_grower/features/splash_screen/splash_screen_bindings.dart';
import 'package:apple_grower/navigation/get_pages.dart';
import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Apple Bilty',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        primaryColor: Colors.tealAccent.shade700,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
     initialRoute: RoutesConstant.splash,
      initialBinding: SplashScreenBindings(),
      getPages: getPages,
    );
  }
}
