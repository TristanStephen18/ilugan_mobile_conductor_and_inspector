import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class Auth {
  Future<void> onLogout(String compID, String busnum, String empID)async {
    await FirebaseFirestore.instance.collection('companies').doc(compID).collection('buses').doc(busnum).update({
      'conductor': ""
    });
    await FirebaseFirestore.instance.collection('companies').doc(compID).collection('employees').doc(empID).update({
      'inbus': ""
    });

    print('Data updated');
  }

}