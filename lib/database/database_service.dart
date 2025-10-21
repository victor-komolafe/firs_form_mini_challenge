import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // Future<void> create(
  // {required String path, required Map<String, dynamic> data}) async {
  // final DatabaseReference ref = _firebaseDatabase.ref().child(path);
  // await ref.set(data);
  // }
//

  Future<void> createFarmer({
    required String name,
    required String age,
    required String gender,
    required String phoneNumber,
    required String nin,
    required String lga,
    required String wardResidence,
    required String? dob,
    required String? address,
    required String? registrationDate,
    required String farmingField,
    required String? profileImagePath,
  }) async {
    if (userId == null) throw Exception('User not authenticated');

    try {
      //create farmer db with child userId
      await _firebaseDatabase.ref().child('farmers').child(userId!).set({
        'name': name,
        'age': age,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'nin': nin,
        'lga': lga,
        'address': address,
        'registration date': registrationDate,
        'wardResidence': wardResidence,
        'dob': dob,
        'farmingField': farmingField,
        'createdAt': ServerValue.timestamp,
        'profileImagePath': profileImagePath
      });
      debugPrint('Farmer details created');
    } catch (e) {
      throw Exception('Failed to save farmer data: $e');
    }
  }

  //uploading UserProfile IMage
  // Future<String?> uploadProfileImage(File imageFile) async {
  //   if (userId == null) {
  //     debugPrint('Error: UserID is null');
  //   }
  //   try {
  //     debugPrint('Starting image upload for user: $userId');

  //     final String fileName = 'profile_images/$userId.jpg';
  //     final Reference storageRef =
  //         FirebaseStorage.instance.ref().child(fileName);

  //     debugPrint('Uploading to Firebase Storage...');
  //     final UploadTask uploadTask = storageRef.putFile(imageFile);
  //     final TaskSnapshot snapshot = await uploadTask;

  //     final String downloadUrl = await snapshot.ref.getDownloadURL();
  //     debugPrint('Upload successful! Download URL: $downloadUrl');

  //     return downloadUrl; // This should be a https:// URL
  //   } catch (e) {
  //     debugPrint('Error uploading image: $e');
  //     return null;
  //   }
  // }

  //read farmer's details
  Future<Map<String, dynamic>?> getFarmerDetails() async {
    if (userId == null) return null;
    try {
      final snapshot =
          await _firebaseDatabase.ref().child('farmers').child(userId!).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        debugPrint('Retrieved farmer data: $data');
        // if (data['dob'] != null) {
        //   data['dob'] = DateTime.fromMillisecondsSinceEpoch(data['dob'] as int);
        // }
        return data;

        // return Map<String, dynamic>.from(snapshot.value as Map);

        // Convert timestamp back to DateTime if needed
      }
    } catch (e) {
      throw Exception('Failed to get farmer\'s data: $e');
    }
    return null;
  }

  Future<void> updateFarmerDetails({
    required String name,
    required String age,
    required String gender,
    required String phoneNumber,
    required String nin,
    required String lga,
    required String wardResidence,
    required String dob,
    required String farmingField,
    required String address,
    required String registrationDate,
    String? profileImagePath,
  }) async {
    if (userId == null) throw Exception('User not authenticated');

    try {
      // Update existing record instead of creating new one
      await _firebaseDatabase.ref().child('farmers').child(userId!).update({
        'name': name,
        'age': age,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'nin': nin,
        'lga': lga,
        'wardResidence': wardResidence,
        'dob': dob,
        'farmingField': farmingField,
        'address': address,
        'registrationDate': registrationDate,
        'profileImagePath': profileImagePath,
        'updatedAt': ServerValue.timestamp, // Add update timestamp
      });
      debugPrint('Farmer details updated successfully');
    } catch (e) {
      throw Exception('Failed to update farmer data: $e');
    }
  }

  // Delete farmer data
  Future<void> deleteFarmerDetails() async {
    if (userId == null) throw Exception('User not authenticated');

    try {
      await _firebaseDatabase.ref().child('farmers').child(userId!).remove();
      debugPrint('Farmer\'s details deleted');
    } catch (e) {
      throw Exception('Failed to delete farmer data: $e');
    }
  }

  Future<bool> hasFarmerProfile() async {
    if (userId == null) return false;

    try {
      final snapshot =
          await _firebaseDatabase.ref().child('farmers').child(userId!).get();
      bool exists = snapshot.exists;
      debugPrint('Farmer profile exists: $exists');
      return exists;
    } catch (e) {
      debugPrint('Error checking farmer profile: $e');
      return false;
    }
  }

  // Future<DataSnapshot?> read({required String path}) async {
  //   final DatabaseReference ref = _firebaseDatabase.ref().child(path);
  //   final DataSnapshot snapshot = await ref.get();
  //   return snapshot.exists ? snapshot : null;
  // }

  // Future<void> delete({required String path}) async {
  //   final DatabaseReference ref = _firebaseDatabase.ref().child(path);
  //   await ref.remove();
  // }
}
