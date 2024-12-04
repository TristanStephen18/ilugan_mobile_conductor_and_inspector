import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class SeatAssignmentScreen extends StatefulWidget {
  const SeatAssignmentScreen(
      {super.key,
      required this.busnum,
      required this.compId,
      required this.requestId,
      required this.numofseats});

  final String busnum;
  final String compId;
  final String requestId;
  final int numofseats;

  @override
  State<SeatAssignmentScreen> createState() => _SeatAssignmentScreenState();
}

class _SeatAssignmentScreenState extends State<SeatAssignmentScreen> {
  int? totalSeats;
  Map<int, String> seatStatuses = {};
  List<int> selectedSeats = [];

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
    });
  }

  void updatebusseatstatuses() async {
    try {
      for (var i = 0; i <= selectedSeats.length; i++) {
        print(selectedSeats[i]);
        await FirebaseFirestore.instance
            .collection('companies')
            .doc(widget.compId)
            .collection('buses')
            .doc(widget.busnum)
            .collection('seats')
            .doc(selectedSeats[i].toString())
            .update({'status': 'reserved'});
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: CustomText(
          content: 'Assign Seats',
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
          : Column(
              children: [
                // Seat Layout
                Expanded(
                  child: buildSeatLayout(totalSeats!),
                ),
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
                // Assign Seats Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      print(selectedSeats.length);
                      if (widget.numofseats < selectedSeats.length) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Selected seats are too many you only needed ${widget.numofseats}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }else if(widget.numofseats > selectedSeats.length){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Selected seats are not enough you need ${widget.numofseats}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }else{
                        assignSeats(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.sizeOf(context).width / 1.2, 60),
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Assign Seats',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
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
    bool isSelected = selectedSeats.contains(seatNumber);

    return GestureDetector(
      onTap: () {
        if (seatStatus == 'available') {
          setState(() {
            if (isSelected) {
              selectedSeats.remove(seatNumber);
            } else {
              selectedSeats.add(seatNumber);
            }
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
          color: isSelected
              ? Colors.blue
              : seatStatus == 'available'
                  ? Colors.green
                  : seatStatus == 'occupied'
                      ? Colors.red
                      : Colors.yellow, // Default for reserved or unknown status
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
      ),
    );
  }

  void assignSeats(BuildContext context) async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No seats selected! Please select seats to assign."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final requestRef = FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compId)
          .collection('buses')
          .doc(widget.busnum)
          .collection('requests')
          .doc(widget.requestId);

      await requestRef.update({
        'status': 'accepted',
        'seats': selectedSeats,
      });

      updatebusseatstatuses();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Seats successfully assigned!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Close the seat assignment screen
      Navigator.pop(context); // Close the request detail screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error assigning seats: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
