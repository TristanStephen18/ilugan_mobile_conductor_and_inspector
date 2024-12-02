// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/helpers.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/ticketdetails.dart';
// import 'package:iluganmobile_conductors_and_inspector/helpers/busfunctions.dart';
import 'package:intl/intl.dart';

class ToAccomplish extends StatefulWidget {
  final String companyId;
  final String busNum;

  const ToAccomplish(
      {required this.companyId, required this.busNum, super.key});

  @override
  State<ToAccomplish> createState() => _ToAccomplishState();
}

class _ToAccomplishState extends State<ToAccomplish> {
  String? id;

  @override
  Widget build(BuildContext context) {
    String today = DateFormat.yMMMMd('en_US').format(DateTime.now());

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .collection('buses')
          .doc(widget.busNum)
          .collection('reservations')
          .where('accomplished', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Failed to fetch data: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No pending reservations for today"));
        }

        // Filter reservations for today's date
        List<Map<String, dynamic>> filteredReservations = snapshot.data!.docs
            .map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              String reservationDate =
                  DateFormat.yMMMMd('en_US').format(data['date_time'].toDate());
              return {
                ...data,
                'id': doc.id, // Include document ID for display
                'isToday': reservationDate == today,
              };
            })
            .where((reservation) => reservation['isToday'])
            .toList();

        if (filteredReservations.isEmpty) {
          return const Center(child: Text("No pending reservations for today"));
        }

        // Display the list of today's reservations
        return ListView.builder(
          itemCount: filteredReservations.length,
          itemBuilder: (context, index) {
            final reservation = filteredReservations[index];
            final reservationDateTime =
                (reservation['date_time'] as Timestamp).toDate();

            return Card(
              elevation: 10,
              child: ListTile(
                title: Text('Reservation #${reservation['id']}'),
                subtitle: Text(
                  'Date: ${DateFormat('MM-dd-yyyy - hh:mm a').format(reservationDateTime)}\n'
                  ,
                ),
                trailing: const Icon(Icons.pending),
                onTap: () async {
                  id = await Passengerhelper()
                      .getIdImage(reservation['passengerId']);
                  String? type = await Passengerhelper()
                      .gettype(reservation['passengerId']);
                  print(id);
                  print(type);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ReservationDetails(
                            from: reservation['from'],
                            to: reservation['to'],
                            distance: reservation['distance'],
                            fare: reservation['amount'],
                            passID: reservation['passengerId'],
                            seats: reservation['seats_reserved'],
                            idurl: id,
                            resnum: reservation['id'],
                            type: type.toString(),
                            
                          )));
                },
              ),
            );
          },
        );
      },
    );
  }
}


