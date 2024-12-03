import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class SeatManagementScreen extends StatefulWidget {
  const SeatManagementScreen(
      {super.key, required this.busnum, required this.compId});

  final String busnum;
  final String compId;

  @override
  State<SeatManagementScreen> createState() => _SeatManagementScreenState();
}

class _SeatManagementScreenState extends State<SeatManagementScreen> {
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
          .doc(widget.compId)
          .collection('buses')
          .doc(widget.busnum)
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
    FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.compId)
        .collection('buses')
        .doc(widget.busnum)
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
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      toolbarHeight: 50,
      title: CustomText(
        content: 'Seat Viewer',
        fsize: 20,
        fontcolor: Colors.white,
        fontweight: FontWeight.w500,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
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
      ],
      backgroundColor: Colors.green,
    ),
    body: totalSeats == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seat Layout
                SizedBox(
                  height: 600, // Set a fixed height for the seat layout
                  child: buildSeatLayout(totalSeats!),
                ),
                const SizedBox(height: 20),
                // Legends Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildLegend('Available', Colors.green),
                      buildLegend('Occupied', Colors.redAccent),
                      buildLegend('Reserved', Colors.greenAccent),
                    ],
                  ),
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: totalRows,
        itemBuilder: (context, rowIndex) {
          if (rowIndex == totalRows - 1) {
            // Last row with 5 seats
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  5, (index) => buildSeatIcon((fullRows * 4) + index + 1)),
            );
          } else {
            // Regular 2x2 layout
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                    2, (index) => buildSeatIcon(rowIndex * 4 + index + 1)),
                const SizedBox(width: 20), // Aisle space
                ...List.generate(
                    2, (index) => buildSeatIcon(rowIndex * 4 + 2 + index + 1)),
              ],
            );
          }
        },
      ),
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
                : Colors.greenAccent, // Default for unknown status
      ),
      width: 50,
      height: 60,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chair,
            color: Colors.white,
          ),
          Text(
            "$seatNumber",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
