import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class Auth {
  void onLogout(String compID, String busnum, String empID){
    FirebaseFirestore.instance.collection('companies').doc(compID).collection('buses').doc(busnum).update({
      'conductor': ""
    });
    FirebaseFirestore.instance.collection('companies').doc(compID).collection('employees').doc(empID).update({
      'inbus': ""
    });

    print('Data updated');
  }
}