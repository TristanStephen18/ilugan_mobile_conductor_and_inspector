import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/firebase_helpers/fetching.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class SeatverificationScreen extends StatefulWidget {
  SeatverificationScreen({super.key, required this.compid, required this.busid});

  final String compid;
  final String busid;

  @override
  State<SeatverificationScreen> createState() => _SeatverificationScreenState();
}

class _SeatverificationScreenState extends State<SeatverificationScreen> {
  String? id;

  @override
  void initState() {
    super.initState();
    getid();
  }

  void getid() async {
    String? response = await Data().getEmpId(widget.compid);
    setState(() {
      id = response;
    });
  }

  Future<void> _onYesPressed() async {
    print('click');
    try {
      // Update the `inspected_by` field in the bus document
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compid)
          .collection('buses')
          .doc(widget.busid)
          .update({'inspected_by': id});

      // Add an inspection alert with validation passed and empty reason
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compid)
          .collection('inspectionalerts')
          .add({
        'busnumber': widget.busid,
        'context': 'Inspected by $id',
        'validation': 'passed',
        'reason': '',
        'datetime': DateTime.now()
      });

      // Show success alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inspection Successful'),
          content: const Text('The seat information has been verified.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error updating inspection: $e');
    }
  }

  Future<void> _onNoPressed() async {
    TextEditingController reasonController = TextEditingController();

    // Show dialog to get the reason
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Provide a Reason'),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              hintText: 'Reason for incorrect seat information',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get reason and close dialog
                String reason = reasonController.text;
                Navigator.pop(context);

                try {
                  // Add an inspection alert with validation failed and provided reason
                  await FirebaseFirestore.instance
                      .collection('companies')
                      .doc(widget.compid)
                      .collection('inspectionalerts')
                      .add({
                    'busnumber': widget.busid,
                    'context': 'Inspected by $id',
                    'validation': 'failed',
                    'reason': reason,
                    'datetime': DateTime.now()
                  });

                  // Show success alert
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Inspection Failed'),
                      content: const Text('The seat information has been flagged.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  print('Error logging inspection alert: $e');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: CustomText(
          content: widget.busid,
          fsize: 20,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Image(
            image: AssetImage("assets/images/logo.png"),
            height: 50,
            width: 50,
          ),
          Gap(10),
        ],
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/images/icons/choose.png'),
                width: 200,
                height: 200,
              ),
            ),
            const Gap(20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('companies')
                  .doc(widget.compid)
                  .collection('buses')
                  .doc(widget.busid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Bus not found'));
                }

                var busdata = snapshot.data!.data() as Map<String, dynamic>;
                int reservedSeats = busdata['reserved_seats'] ?? 0;
                int occupiedSeats = busdata['occupied_seats'] ?? 0;
                int availableSeats = busdata['available_seats'] ?? 0;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSeatInfoCard(
                          title: 'Reserved',
                          count: reservedSeats,
                          color: const Color.fromARGB(255, 86, 143, 60),
                        ),
                        _buildSeatInfoCard(
                          title: 'Occupied',
                          count: occupiedSeats,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        _buildSeatInfoCard(
                          title: 'Available',
                          count: availableSeats,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const Gap(30),
                    const Text(
                      'Is the seat information correct?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(270),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onYesPressed,
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onNoPressed,
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: const Text(
                              'No',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatInfoCard({required String title, required int count, required Color color}) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
