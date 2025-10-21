import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/database/database_service.dart';
import 'package:firs_mini_project/screens/farmer_form_screen.dart';
// import 'package:firs_mini_project/constants.dart'
import 'package:firs_mini_project/screens/splash_screen.dart';
import 'package:firs_mini_project/widgets/custom_dialog_widget.dart';
import 'package:firs_mini_project/widgets/platform_alert_widget.dart';
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
  final String farmingField;
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
      required this.farmingField,
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
      debugPrint('Image file does not exist at: ${profileImageUrl!}');
      return Icon(
        Icons.person,
        size: 60,
        color: Colors.grey[600],
      );
    }

    debugPrint('Image file found, loading from: ${profileImageUrl!}');
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDetailsDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      title: 'Clear Details',
      content:
          'Are you sure you want to delete all your farmer details? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmColor: Colors.red,
      icon: const Icon(Icons.warning, color: Colors.orange, size: 32),
      onConfirm: () {
        Navigator.of(context).pop(); // Close dialog
        _clearUserDetails(context);
      },
    );
  }

  Future<void> _clearUserDetails(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder<void>(
          // Run the deletion + local file cleanup inside the future
          future: (() async {
            DatabaseService dbService = DatabaseService();
            await dbService.deleteFarmerDetails();

            if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
              final file = File(profileImageUrl!);
              if (file.existsSync()) {
                await file.delete();
                debugPrint('Local image file deleted: $profileImageUrl');
              }
            }
          })(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                content: SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (snapshot.hasError) {
              // Close dialog and show error
              Future.microtask(() {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error clearing details: ${snapshot.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
              return const SizedBox.shrink();
            }

            // Success: close dialog, show success snackbar and navigate
            Future.microtask(() {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Details cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const FarmerFormScreen()),
              );
            });
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final file = File(profileImageUrl!);
    debugPrint('ProfileImagePath in UserFormDetails: $profileImageUrl');
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('User Details'),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: _buildProfileImage(),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 120,
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildDetailRow('Age', age),
                            _buildDetailRow('Gender', gender),
                            _buildDetailRow('Phone', phoneNumber),
                            _buildDetailRow('NIN', nin),
                            _buildDetailRow('Date of Birth', dob),
                            _buildDetailRow('LGA', lga),
                            _buildDetailRow('Ward', wardResidence),
                            _buildDetailRow('Address', address),
                            // if (farmingField != null)
                            _buildDetailRow('Farming Field', farmingField),
                            _buildDetailRow(
                                'Registration Date', registrationDate),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: PressableButton(
                            text: "Edit Details",
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Replace the current screen stack with the login screen tab
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: PressableButton(
                            color: Color.fromARGB(255, 199, 81, 57),
                            text: "Clear Submissions",
                            onPressed: () {
                              _showClearDetailsDialog(context);
                              // Replace the current screen stack with the login screen tab
                            },
                          ),
                        ),
                      ],
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
                        CustomDialog.show(
                          context: context,
                          title: 'Clear Details',
                          content: 'Are you sure you want to Log Out?',
                          confirmText: 'Delete',
                          cancelText: 'Cancel',
                          confirmColor: Colors.red,
                          icon: const Icon(Icons.warning,
                              color: Colors.orange, size: 32),
                          onConfirm: () async {
                            Navigator.of(context).pop(); // Close dialog

                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SplashScreen()));
                          },
                        );

                        // Replace the current screen stack with the login screen tab
                      },
                      color: Color.fromARGB(255, 152, 41, 33),
                    ),
                  ),
                  const Spacer(),
                ])));
  }
}
