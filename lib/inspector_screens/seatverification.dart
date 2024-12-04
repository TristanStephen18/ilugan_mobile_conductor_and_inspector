import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class SeatverificationScreen extends StatefulWidget {
  const SeatverificationScreen({
    super.key,
    required this.compid,
    required this.busid,
  });

  final String compid;
  final String busid;

  @override
  State<SeatverificationScreen> createState() => _SeatverificationScreenState();
}

class _SeatverificationScreenState extends State<SeatverificationScreen> {
  int? totalSeats;
  Map<int, String> seatStatuses = {};

  @override
  void initState() {
    super.initState();
    fetchSeatData();
    setupSeatStatusListener();
  }

  Future<void> fetchSeatData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compid)
          .collection('buses')
          .doc(widget.busid)
          .get();

      if (snapshot.exists) {
        setState(() {
          totalSeats = (snapshot.data() as Map<String, dynamic>)['total_seats'];
        });
      }
    } catch (error) {
      print("Error fetching seat data: $error");
    }
  }

  void setupSeatStatusListener() {
    try{
      FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.compid)
        .collection('buses')
        .doc(widget.busid)
        .collection('seats')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      Map<int, String> updatedStatuses = {};
      for (var doc in snapshot.docs) {
        int seatNumber = int.parse(doc.id);
        String status = (doc.data() as Map<String, dynamic>)['status'];
        updatedStatuses[seatNumber] = status;
      }
      setState(() {
        seatStatuses = updatedStatuses;
      });
      print(seatStatuses);
    });
    }catch(error){
      print(error);
    }
  }

  Future<void> _onYesPressed() async {
    // Update inspection details for validation passed
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compid)
          .collection('buses')
          .doc(widget.busid)
          .update({'inspected_by': 'Inspector'});

      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compid)
          .collection('inspectionalerts')
          .add({
        'busnumber': widget.busid,
        'context': 'Inspected and validated',
        'validation': 'passed',
        'reason': '',
        'datetime': DateTime.now(),
      });

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
                Navigator.pop(context);

                try {
                  await FirebaseFirestore.instance
                      .collection('companies')
                      .doc(widget.compid)
                      .collection('inspectionalerts')
                      .add({
                    'busnumber': widget.busid,
                    'context': 'Inspection failed',
                    'validation': 'failed',
                    'reason': reasonController.text,
                    'datetime': DateTime.now(),
                  });

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
        toolbarHeight: 50,
        title: CustomText(
          content: 'Bus: ${widget.busid}',
          fsize: 20,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: totalSeats == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dynamic Seat Layout
                  SizedBox(
                    height: 600,
                    child: buildSeatLayout(totalSeats!),
                  ),
                  const SizedBox(height: 20),
                  // Legends
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildLegend('Available', Colors.green),
                        buildLegend('Occupied', Colors.redAccent),
                        buildLegend('Reserved', Colors.yellow),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Verification Buttons
                   CustomText(
                    content: 'Is the seat information correct?',
                    fsize: 17,
                    fontweight: FontWeight.bold,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onYesPressed(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => _onNoPressed(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
          margin: const EdgeInsets.only(right: 8.0),
        ),
        CustomText(content: label, fsize: 16, fontcolor: Colors.black),
      ],
    );
  }

  Widget buildSeatLayout(int totalSeats) {
    int fullRows = ((totalSeats - 5) / 4).ceil(); // Rows with 4 seats each
    int totalRows = fullRows + 1; // Include the back row

    return ListView.builder(
      itemCount: totalRows,
      itemBuilder: (context, rowIndex) {
        if (rowIndex == totalRows - 1) {
          // Last row with 5 seats
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              5,
              (index) => buildSeatIcon((fullRows * 4) + index + 1),
            ),
          );
        } else {
          // Regular 2x2 layout
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(
                2,
                (index) => buildSeatIcon(rowIndex * 4 + index + 1),
              ),
              const SizedBox(width: 20), // Aisle space
              ...List.generate(
                2,
                (index) => buildSeatIcon(rowIndex * 4 + 2 + index + 1),
              ),
            ],
          );
        }
      },
    );
  }

  Widget buildSeatIcon(int seatNumber) {
    String seatStatus = seatStatuses[seatNumber] ?? 'unknown';

    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: seatStatus == 'available'
            ? Colors.green
            : seatStatus == 'occupied'
                ? Colors.red
                : Colors.yellow, // Default for unknown status
      ),
      width: 50,
      height: 60,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chair, color: Colors.white),
          Text(
            "$seatNumber",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
