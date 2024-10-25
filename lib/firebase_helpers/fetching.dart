// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Data {
  Future<Map<String, dynamic>?> getEmployeeData(String companyid) async {
  DocumentSnapshot snapshots = await FirebaseFirestore.instance
      .collection('companies')
      .doc(companyid)
      .collection('employees')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  if (snapshots.exists) {
    var docs = snapshots.data() as Map<String, dynamic>;
    return {
      'companyid' : companyid,
      'name': docs['employee_name'],
      'id': docs['id'],
      'type': docs['type'],
      'email': docs['email'],
      'active': docs['active'],
      'inbus' : docs['inbus']
    };
  } else {
    print('Document does not exist');
    return null;
  }
}
}



// class Profiledata {
//   final name;
//   final email;
//   final id;

//   Profiledata({
//     required this.name,
//     required this.email,
//     required this.id
//   });
// }