// import 'package:firs_mini_project/screens/farmer_form_screen.dart';
// import 'package:firs_mini_project/screens/farmer_form_screen.dart';
// import 'package:firs_mini_project/screens/login_screen.dart';
import 'package:firs_mini_project/screens/farmer_form_screen.dart';
import 'package:firs_mini_project/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //It ensures that the Flutter engine and the widget framework are fully initialized before your app executes any code that relies on them.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue),
        // home: const SplashScreen());
        home: const FarmerFormScreen());
  }
}
