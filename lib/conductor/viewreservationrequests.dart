import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/requestdetails.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class ReseravtionRequestsHolderScreen extends StatefulWidget {
  const ReseravtionRequestsHolderScreen({
    super.key,
    required this.compId,
    required this.busnum,
  });

  final String compId;
  final String busnum;

  @override
  State<ReseravtionRequestsHolderScreen> createState() =>
      _ReseravtionRequestsHolderScreenState();
}

class _ReseravtionRequestsHolderScreenState
    extends State<ReseravtionRequestsHolderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: CustomText(
          content: 'Reservation Requests',
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Accepted"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RequestList(
            compId: widget.compId,
            busnum: widget.busnum,
            status: 'pending',
          ),
          RequestList(
            compId: widget.compId,
            busnum: widget.busnum,
            status: 'accepted',
          ),
          RequestList(
            compId: widget.compId,
            busnum: widget.busnum,
            status: 'rejected',
          ),
        ],
      ),
    );
  }
}

class RequestList extends StatelessWidget {
  const RequestList({
    super.key,
    required this.compId,
    required this.busnum,
    required this.status,
  });

  final String compId;
  final String busnum;
  final String status;

  @override
  Widget build(BuildContext context) {
    final collectionRef = FirebaseFirestore.instance
        .collection('companies')
        .doc(compId)
        .collection('buses')
        .doc(busnum)
        .collection('requests');

    return StreamBuilder<QuerySnapshot>(
      stream: collectionRef.where('status', isEqualTo: status).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No requests found."));
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pickup: ${request['pickup_location'].substring(0, 30)}..."),
                    Text("Destination: ${request['destination'].substring(0, 30)}..."),
                    Text("Fare: ${request['fare']} Php"),
                    Text("Passengers: ${request['totalpassengers']}"),
                  ],
                ),
                trailing: Text(
                  "Status: ${request['status']}",
                  style: TextStyle(
                    color: status == 'accepted'
                        ? Colors.green
                        : (status == 'rejected' ? Colors.red : Colors.orange),
                  ),
                ),
                onTap: status == 'pending'
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetailScreen(
                              request: request,
                              compId: compId,
                              busnum: busnum,
                            ),
                          ),
                        );
                      }
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}

