import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  // String compId;
  // String? bus_num;
  // String conID;
  @override
  Widget build(BuildContext context) {
    return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 1'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 2'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
              ],
            ),
          );
  }
}