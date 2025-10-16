import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    required DateTime? dob,
    required String farmingField,
  }) async {
    if (userId == null) throw Exception('User not authenticated');
    try {
      await _firebaseDatabase.ref().child('farmers').child(userId!).set({
        'name': name,
        'age': age,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'nin': nin,
        'lga': lga,
        'wardResidence': wardResidence,
        'dob': dob?.microsecondsSinceEpoch,
        'farmingField': farmingField,
        'createdAt': ServerValue.timestamp,
      });
      debugPrint('Farmer details created');
    } catch (e) {
      throw Exception('Failed to save farmer data: $e');
    }
  }

  Future<Map<String, dynamic>?> getFarmerDetails() async {
    if (userId == null) return null;
    try {
      final snapshot =
          await _firebaseDatabase.ref().child('farmers').child(userId!).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        if (data['dob'] != null) {
          data['dob'] = DateTime.fromMillisecondsSinceEpoch(data['dob'] as int);
        }
        return data;

        // return Map<String, dynamic>.from(snapshot.value as Map);

        // Convert timestamp back to DateTime if needed
      }
    } catch (e) {
      throw Exception('Failed to get farmer\'s data: $e');
    }
  }

  Future<void> updateFarmer(Map<String, dynamic> updates) async {
    if (userId == null) throw Exception('User not authenticated');

    try {
      await _firebaseDatabase
          .ref()
          .child('farmers')
          .child(userId!)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update farmer data: $e');
    }
  }

  // Delete farmer data
  Future<void> deleteFarmer() async {
    if (userId == null) throw Exception('User not authenticated');

    try {
      await _firebaseDatabase.ref().child('farmers').child(userId!).remove();
    } catch (e) {
      throw Exception('Failed to delete farmer data: $e');
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
