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
            ])));
  }
}
