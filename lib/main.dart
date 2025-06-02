// import 'package:firs_mini_project/screens/farmer_form_screen.dart';
import 'package:firs_mini_project/screens/farmer_form_screen.dart';
import 'package:firs_mini_project/screens/login_screen.dart';
import 'package:firs_mini_project/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue),
        home: const SplashScreen());
    // home: const FarmerFormScreen());
  }
}
