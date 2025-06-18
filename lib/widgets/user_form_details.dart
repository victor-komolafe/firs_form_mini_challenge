import 'package:firebase_auth/firebase_auth.dart';
import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/screens/splash_screen.dart';
import 'package:firs_mini_project/widgets/pressable_button.dart';
import 'package:flutter/material.dart';

class UserFormDetails extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String phoneNumber;
  final String nin;

  const UserFormDetails(
      {super.key,
      required this.name,
      required this.age,
      required this.gender,
      required this.nin,
      required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('User Details'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Name: $name'),
              const SizedBox(height: 8),
              Text('Age: $age'),
              const SizedBox(height: 8),
              Text('Gender: $gender'),
              const SizedBox(height: 8),
              Text('Phone Number: $phoneNumber'),
              const SizedBox(height: 8),
              Text('NIN: $nin'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PressableButton(
                  text: "Edit Details",
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Replace the current screen stack with the login screen tab
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: PressableButton(
                  text: "Log Details",
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SplashScreen()));

                    // Replace the current screen stack with the login screen tab
                  },
                  color: Color.fromARGB(255, 152, 41, 33),
                ),
              ),
              const Spacer(),
            ])));
  }
}
