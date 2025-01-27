import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class Auth {
  Future<void> onLogout(String compID, String busnum, String empID)async {
    await FirebaseFirestore.instance.collection('companies').doc(compID).collection('buses').doc(busnum).update({
      'conductor': ""
    });
    await FirebaseFirestore.instance.collection('companies').doc(compID).collection('employees').doc(empID).update({
      'inbus': "", 
      "status" : "inactive"
    });
    await FirebaseFirestore.instance.collection('ilugan_mobile_users').doc(empID).update({
      "inbus" : ""
    });
    print('Data updated');
  }

  Future<void> onBusChosen(String compID, String empID) async{
   await FirebaseFirestore.instance.collection('companies').doc(compID).collection('employees').doc(empID).update({ 
      "status" : "active"
    });

    print('Is active');
  }
  
  Future<void> oninspectorlogin(String compID, String empID)async {
    print('Logging out');
    await FirebaseFirestore.instance.collection('companies').doc(compID).collection('employees').doc(empID).update({ 
      "status" : "active"
    });

    print('Is active');
  }

  Future<void> oninspectorlogout(String compID, String empID) async {
   await FirebaseFirestore.instance.collection('companies').doc(compID).collection('employees').doc(empID).update({ 
      "status" : "inactive"
    });

    print('Is active');
  }
}