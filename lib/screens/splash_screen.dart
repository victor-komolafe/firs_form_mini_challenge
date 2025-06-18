import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firs_mini_project/screens/farmer_form_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));


    //TODO: Implement Stream builder for Firebase Auth USer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/splash_screen.png', fit: BoxFit.cover);
  }
}
