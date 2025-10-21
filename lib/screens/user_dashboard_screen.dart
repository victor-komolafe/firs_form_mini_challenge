import 'package:firs_mini_project/database/database_service.dart';
import 'package:firs_mini_project/widgets/user_form_details.dart';
import 'package:flutter/material.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  Map<String, dynamic>? farmerData;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFarmerData();
  }

  Future<void> _loadFarmerData() async {
    try {
      DatabaseService dbService = DatabaseService();
      final data = await dbService.getFarmerDetails();

      setState(() {
        farmerData = data;
        isLoading = false;
      });

      debugPrint('Loaded farmer data: $data');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (farmerData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: const Center(
          child: Text('No farmer data found. Please complete your profile.'),
        ),
      );
    }

    // Navigate to UserFormDetails with loaded data
    return UserFormDetails(
      name: farmerData!['name'] ?? '',
      age: farmerData!['age'] ?? '',
      gender: farmerData!['gender'] ?? '',
      phoneNumber: farmerData!['phoneNumber'] ?? '',
      nin: farmerData!['nin'] ?? '',
      dob: farmerData!['dob'] ?? '',
      lga: farmerData!['lga'] ?? '',
      wardResidence: farmerData!['wardResidence'] ?? '',
      address: farmerData!['address'] ?? '',
      registrationDate: farmerData!['registration date'] ?? '',
      farmingField: farmerData!['farmingField'] ?? '',
      profileImageUrl:
          farmerData!['profileImagePath'], // Load the saved image path
    );
  }
}
