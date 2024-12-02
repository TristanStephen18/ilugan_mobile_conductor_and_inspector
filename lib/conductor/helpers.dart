// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

class Conductor {
  void changedstatus(String status, String compid) {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(compid)
        .collection('employees')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status': status});
  }

  void onsuccessfulscanned(String passengerid) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('passengers')
        .doc(passengerid)
        .collection('reservations')
        .where('label', isEqualTo: 'pending')
        .limit(1)
        .get();

    var doc = query.docs.first;

    await doc.reference.update({
        'label' : 'scanned'
      }).then((val){
        print('pending to scanned real quick');
      });
    // for(var docs in query.docs){
    //   await docs.reference.update({
    //     'label' : 'scanned'
    //   });
    // }
  }
}

class Passengerhelper{
  Future<String?> getIdImage(String id) async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('passengers').doc(id).get();

    if(snapshot.exists){
      var data = snapshot.data() as Map<String, dynamic>;
      print(data['id']);

      return data['id'];
    }
    return null;
  }

  Future<String?> gettype(String id) async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('passengers').doc(id).get();

    if(snapshot.exists){
      var data = snapshot.data() as Map<String, dynamic>;
      print(data['id']);

      return data['type'];
    }
    return null;
  }
}
