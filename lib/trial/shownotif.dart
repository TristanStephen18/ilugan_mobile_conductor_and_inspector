import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {

  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNotificationPermission();
  }

  void requestNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Show a dialog to ask the user to allow notifications
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Don\'t Allow'),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications().requestPermissionToSendNotifications().then((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Allow'),
              ),
            ],
          ),
        );
      }
    });
  }

  void showNotification() {
    print("pressed");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Hello!',
        body: 'This is a notification triggered by button click.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(counter == 2){
      showNotification();
    }
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            setState(() {
              counter ++;
            });
          }, child: const Text("Predd")),
          OutlinedButton(onPressed: showNotification, child: const Text("Press Here"))
        ],
      ),
    );
  }
}