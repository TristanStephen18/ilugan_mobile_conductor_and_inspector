import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/seatassignmentscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({
    super.key,
    required this.request,
    required this.compId,
    required this.busnum,
  });

  final QueryDocumentSnapshot request;
  final String compId;
  final String busnum;

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final idsField = request['ids'] as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: CustomText(
          content: 'Requests Details',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Bus Image and Title
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.greenAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icons/choose.png',
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Reservation Request',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // IDS Field Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: idsField.isEmpty
                  ? const Text(
                      "All Regulars",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : _ImageDisplay(idsField: idsField),
            ),
            const SizedBox(height: 16),
            // Request Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDetailCard(
                    title: "Pickup Location",
                    value: request['pickup_location'],
                    icon: Icons.location_on,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "Destination",
                    value: request['destination'],
                    icon: Icons.location_city,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "Fare",
                    value: "${request['fare']} Php",
                    icon: Icons.monetization_on,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "Passengers",
                    value: "${request['totalpassengers']}",
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "Distance",
                    value: "${request['distance']} km",
                    icon: Icons.directions,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "PWDs",
                    value: "${request['pwds']}",
                    icon: Icons.accessible,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "Seniors",
                    value: "${request['seniors']}",
                    icon: Icons.elderly,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "Students",
                    value: "${request['students']}",
                    icon: Icons.school,
                    color: Colors.green,
                  ),
                  _buildDetailCard(
                    title: "Regulars",
                    value: "${request['regulars']}",
                    icon: Icons.person,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:  (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SeatAssignmentScreen(busnum: busnum, compId: compId, requestId: request.id, numofseats: (request['pwds'] + request['seniors'] + request['regulars'] + request['students']),)));
                      },
                      icon: const Icon(
                        Icons.check_circle,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showRejectionDialog(context),
                      icon: const Icon(Icons.cancel,
                          size: 24, color: Colors.white),
                      label: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.8),
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  void _updateRequestStatus(BuildContext context, String newStatus) async {
    final requestRef = FirebaseFirestore.instance
        .collection('companies')
        .doc(compId)
        .collection('buses')
        .doc(busnum)
        .collection('requests')
        .doc(request.id);

    await requestRef.update({'status': newStatus});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Request marked as $newStatus")),
    );

    Navigator.pop(context);
  }

  void _showRejectionDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reject Request"),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              hintText: "Enter the reason for rejection",
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Reason cannot be empty"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final requestRef = FirebaseFirestore.instance
                    .collection('companies')
                    .doc(compId)
                    .collection('buses')
                    .doc(busnum)
                    .collection('requests')
                    .doc(request.id);

                await requestRef.update({
                  'status': 'rejected',
                  'reason': reasonController.text.trim(),
                });

                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to the previous screen

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Request rejected successfully")),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}

class _ImageDisplay extends StatelessWidget {
  const _ImageDisplay({Key? key, required this.idsField}) : super(key: key);

  final String idsField;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImageViewer(imageUrl: idsField),
          ),
        );
      },
      child: FutureBuilder<String>(
        future: FirebaseStorage.instance.refFromURL(idsField).getDownloadURL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text(
              'Error loading image',
              style: TextStyle(color: Colors.red),
            );
          }
          return Image.network(
            snapshot.data!,
            height: 200,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
