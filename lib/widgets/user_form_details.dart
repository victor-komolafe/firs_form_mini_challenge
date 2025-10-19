import 'dart:io';

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
  final String dob;
  final String lga;
  final String? profileImageUrl;
  final String address;
  final String registrationDate;
  final String wardResidence;

  const UserFormDetails(
      {super.key,
      required this.name,
      required this.age,
      required this.gender,
      required this.nin,
      this.profileImageUrl,
      required this.address,
      required this.registrationDate,
      required this.phoneNumber,
      required this.lga,
      required this.wardResidence,
      required this.dob});

  Widget _buildProfileImage() {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) {
      return Icon(
        Icons.person,
        size: 60,
        color: Colors.grey[600],
      );
    }

    // Check if file exists at the path
    final file = File(profileImageUrl!);
    if (!file.existsSync()) {
      return Icon(
        Icons.person,
        size: 60,
        color: Colors.grey[600],
      );
    }

    return ClipOval(
      child: Image.file(
        file,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: 60,
            color: Colors.grey[600],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = File(profileImageUrl!);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('User Details'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display profile image
                  _buildProfileImage(),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: $name',
                              style: const TextStyle(fontSize: 16)),
                          Text('Age: $age',
                              style: const TextStyle(fontSize: 16)),
                          Text('Gender: $gender',
                              style: const TextStyle(fontSize: 16)),
                          Text('Phone: $phoneNumber',
                              style: const TextStyle(fontSize: 16)),
                          Text('NIN: $nin',
                              style: const TextStyle(fontSize: 16)),
                          Text('LGA: $lga',
                              style: const TextStyle(fontSize: 16)),
                          Text('Ward: $wardResidence',
                              style: const TextStyle(fontSize: 16)),
                          Text('DOB: $dob',
                              style: const TextStyle(fontSize: 16)),
                          Text('Address: $address',
                              style: const TextStyle(fontSize: 16)),
                          Text('Registration Date: $registrationDate',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),

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
                      text: "Log Out",
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
