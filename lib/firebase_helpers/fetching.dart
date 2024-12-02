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

void getBusRealtimeData(String companyid, String busnum) {
    FirebaseFirestore.instance
      .collection('companies')
      .doc(companyid)
      .collection('buses')
      .doc(busnum).snapshots().listen((DocumentSnapshot snapshot){
        if(snapshot.exists){
          var data = snapshot.data();
          print(data);
        }else{  
          print('Document does not exist');
        }
      });
}

Future<String?> getcompanyname(String id)async {
  DocumentSnapshot snapshots = await FirebaseFirestore.instance
      .collection('companies')
      .doc(id)
      .get();

      if(snapshots.exists){
        var data = snapshots.data() as Map<String, dynamic>;
        return data['company_name'];
        // return 
      }else{
        print('error fetching comapny name');
      }
}

Future<String?> getEmpId(String companyId) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('companies').doc(companyId).collection('employees').doc(FirebaseAuth.instance.currentUser!.uid).get();


  if(snapshot.exists){
    var data = snapshot.data() as Map<String, dynamic>;

      print('Getting employee id'); 

    return data['id'];
  }

  return null;
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