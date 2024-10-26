// ignore_for_file: camel_case_types, deprecated_member_use, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/firebase_helpers/auth.dart';
import 'package:iluganmobile_conductors_and_inspector/firebase_helpers/fetching.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/busfunctions.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class Dashboard_Con extends StatefulWidget {
  final String compId;
  // ignore: non_constant_identifier_names
  final String? bus_num;
  final String? conID;

  const Dashboard_Con({
    super.key,
    required this.compId,
    // ignore: non_constant_identifier_names
    required this.bus_num,
    required this.conID,
  });

  @override
  State<Dashboard_Con> createState() => _Dashboard_ConState();
}

class _Dashboard_ConState extends State<Dashboard_Con> {
  BitmapDescriptor movingbusMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor assignedBusMarker = BitmapDescriptor.defaultMarker;
  String? companyId;
  String? busNum;
  // String? id;
  Set<Marker> markers = {};
  late GoogleMapController mapController;
  final BusFunc helper = BusFunc();
  int available_seats = 0;
  int occupied = 0;
  int reserved = 0;
  String terminal = "";
  String destination="";

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initialize() async {
    print(widget.bus_num);
    await _loadCustomMarkers();
    _listenToBusLocations();
    getuserdata();
    // await Data().getcompanyname();
  }

  String email = "";
  String name = "";
  String id = "";
  String budocID = "";
  String? comapnyname;


  void getuserdata() async {
    var data = await Data().getEmployeeData(widget.compId);
    setState(() {
      email = data?['email'];
      name = data?['name'];
      id = data?['id'];
      busNum = data?['inbus'];
      companyId = data?['companyid'];
    });

    print(email + name + id + busNum.toString());
    getBusRealtimeData(companyId.toString(), busNum.toString());
    String? cname = await Data().getcompanyname(companyId.toString());
    setState(() {
      comapnyname = cname;
    });
    // setState(() {
      
    // });
  }

  void getBusRealtimeData(String companyid, String busnum) {
    FirebaseFirestore.instance
      .collection('companies')
      .doc(companyid)
      .collection('buses')
      .doc(busnum).snapshots().listen((DocumentSnapshot snapshot){
        if(snapshot.exists){
          var data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            available_seats = data['available_seats'];
            reserved = data['reserved_seats'];
            occupied = data['occupied_seats'];
            terminal = data['terminalloc'];
            destination = data['destination'];
          });
          print(data);
        }else{  
          print('Document does not exist');
        }
      });
}

  Future<void> _loadCustomMarkers() async {
    try {
      movingbusMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.2),
        "assets/images/icons/moving_bus_icon.png",
      );
      assignedBusMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.2),
        "assets/images/icons/moving_bus_icon.png",
      );
      setState(() {}); // Update the UI with loaded markers
    } catch (e) {
      print("Error loading custom icons: $e");
    }
  }

  void _listenToBusLocations() {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.compId)
        .collection('buses')
        .snapshots()
        .listen((snapshot) async {
      final newMarkers = <Marker>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final GeoPoint geoPoint = data['current_location'];
        final LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
        final busNumber = data['bus_number'];
        final plateNumber = data['plate_number'];

        if (doc.id == busNum) {
          newMarkers
              .add(_buildAssignedBusMarker(position, busNumber, plateNumber));
          setToLocation(position);
        } else {
          final destination = LatLng(data['destination_coordinates'].latitude,
              data['destination_coordinates'].longitude);
          final distance = await helper.getDistance(position, destination);
          final estimatedTime =
              await helper.getEstimatedTime(position, destination);
          final address = await helper.reverseGeocode(
              position.latitude, position.longitude);

          newMarkers.add(
            _buildMovingBusMarker(doc.id, position, busNumber, plateNumber,
                distance.toString(), estimatedTime.toString(), address),
          );
        }
      }

      setState(() {
        markers
          ..removeWhere((marker) => marker.markerId.value.startsWith('bus_'))
          ..addAll(newMarkers);
      });
    });
  }

  Marker _buildMovingBusMarker(
    String busId,
    LatLng position,
    String busNumber,
    String plateNumber,
    String distance,
    String estimatedTime,
    String address,
  ) {
    return Marker(
      markerId: MarkerId('bus_$busId'),
      position: position,
      icon: movingbusMarker,
      infoWindow: InfoWindow(
        title: 'Bus $busNumber',
        snippet: 'Distance: $distance, ETA: $estimatedTime',
      ),
      onTap: () => _showBusInfoDialog(distance, estimatedTime, address),
    );
  }

  Marker _buildAssignedBusMarker(
      LatLng position, String busNumber, String plateNumber) {
    return Marker(
      markerId: const MarkerId('assignedbus_location'),
      position: position,
      icon: assignedBusMarker,
      infoWindow: InfoWindow(title: 'My Bus\n$busNumber ($plateNumber)'),
    );
  }

  void _showBusInfoDialog(
      String distance, String estimatedTime, String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bus Information'),
        content: Text(
            'Distance from destination: $distance\nETA: $estimatedTime\nAddress: $address'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void setToLocation(LatLng position) {
    CameraPosition cameraPosition =
        CameraPosition(target: position, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  Future<void> logout() async {
     await Auth().onLogout(widget.compId, busNum.toString(),
        FirebaseAuth.instance.currentUser!.uid);
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void panToAssignedBus() {
    if (markers
        .any((marker) => marker.markerId.value == 'assignedbus_location')) {
      Marker? assignedBusMarker = markers.firstWhere(
          (marker) => marker.markerId.value == 'assignedbus_location');
      setToLocation(assignedBusMarker.position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Appdrawers(logoutfunc: logout, conid: id, coname: name, busnum: busNum.toString(), compID: widget.compId,),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 60,
          title: CustomText(
            content: comapnyname != null ? comapnyname.toString() : 'Loading...',
            fsize: 20,
            fontcolor: Colors.yellowAccent,
            fontweight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          actions: const [
            Image(
              image: AssetImage("assets/images/logo.png"),
              height: 50,
              width: 50,
            ),
          ],
          backgroundColor: Colors.redAccent,
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(15.975949534874196, 120.57135500752592),
                zoom: 11,
              ),
              mapType: MapType.normal,
              onMapCreated: (controller) => mapController = controller,
              markers: markers,
            ),
            // Positioned Floating Containers
            Positioned(
              bottom: 20, // Distance from the bottom of the screen
              left: 10, // Distance from the left of the screen
              child: Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.sizeOf(context).width - 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(content: 'Route', fontweight: FontWeight.bold,),
                          const Gap(3),
                          const Icon(Icons.location_on)
                        ],
                      ),
                      Text(
                        '$terminal ------------------------------------- > $destination',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CustomText(content: 'Seats', fontweight: FontWeight.bold,),
                           const Gap(3),
                          const Icon(Icons.chair)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Three grey boxes
                          Column(
                            children: [
                              CustomText(content: 'Available'),
                              Container(
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    available_seats.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CustomText(content: 'Reserved'),
                              Container(
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    reserved.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CustomText(content: 'Occupied'),
                              Container(
                                width: 70,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    occupied.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Center(
                      //   child: ,
                      // )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/icons/choose.png",
                      height: 70,
                      width: 70,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      busNum.toString(), 
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
