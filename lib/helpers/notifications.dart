// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Notifications{
   static Future<void> initializenotifications() async {
    await AwesomeNotifications().initialize(
    null,  // Set your notification icon here
    [
      NotificationChannel(
        channelKey: 'ilugan_notif',
        channelName: 'Ilugan Channel',
        channelDescription: 'Notifying Passengers',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );
  print('NOtifications initialized');
  }

  Future<void> requestNotificationPermissions(BuildContext context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Show a dialog prompting the user to allow notifications
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Allow Notifications'),
          content: Text('This app would like to send you notifications.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Deny'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await AwesomeNotifications().requestPermissionToSendNotifications();
              },
              child: Text('Allow'),
            ),
          ],
        ),
      );
    }
  }
}