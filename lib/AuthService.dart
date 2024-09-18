import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if a user is logged in
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<Map<String, String>> getUserTypeAndCompanyId(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('ilugan_mobile_users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      var doc = querySnapshot.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      
      return {
        'type': data['type'],
        'companyId': data['companyId']
      };
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
