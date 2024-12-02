import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package
import 'package:intl/intl.dart'; // For date formatting
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key, required this.compid, required this.busnum});

  final String compid;
  final String busnum;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Fetch notifications from Firestore
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    print('BUS NUMBER: ${widget.busnum}');
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compid)
          .collection('buses')
          .doc(widget.busnum)
          .collection('responses')
          .get();

      return snapshot.docs.map((doc) {
        return {
          'respondedAt': (doc['respondedAt'] as Timestamp).toDate(),
          'response': doc['response'] as String,
        };
      }).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: CustomText(
          content: 'Notifications',
          fsize: 20,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Image(
            image: AssetImage("assets/images/logo.png"),
            height: 50,
            width: 50,
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading notifications'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No notifications available'),
            );
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final formattedDate = DateFormat('MMMM dd, yyyy h:mm a')
                  .format(notification['respondedAt']);
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text('Admin Responded: ${notification['response']}'),
                  subtitle: Text(formattedDate),
                  leading: const Icon(Icons.notifications),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
