import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';

class Responsemonitoring{
  void listentocompanyresponse(String uid, String busnum)async{
    FirebaseFirestore.instance.collection('companies').doc(uid).collection('buses').doc(busnum).snapshots().listen((DocumentSnapshot doc) async{
      print('Listening to response');
      print(doc);
      var data = doc.data() as Map<String, dynamic>;
      if(data['latest_response'] == null){
        print('empty');
      }else{
        // print('Not empty');
        reponsereceived(data['latest_response']);
        await FirebaseFirestore.instance.collection('companies').doc(uid).collection('buses').doc(busnum).update({
          'latest_response' : null
        });
      }
    });
  }
}

void reponsereceived(String message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 2, // A unique ID for this notification
          channelKey:
              'ilugan_notif', // Channel should match the one initialized
          title: 'Response from admin',
          body: message,
          notificationLayout:
              NotificationLayout.Default, // Default notification layout
          // icon: 'resource://drawable/logo',
          ),
    );
  }

