import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/busfunctions.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';

// ignore: camel_case_types
class Dashboard_Con extends StatefulWidget {
  Dashboard_Con(
      {super.key,
      required this.compId,
      required this.bus_num,
      required this.conID});

  String compId;
  String? bus_num;
  String? conID;

  @override
  State<Dashboard_Con> createState() => _Dashboard_ConState();
}

class _Dashboard_ConState extends State<Dashboard_Con> {
  @override
  void initState() {
    super.initState();
    // customIcon();
    customIconforMovingBuses();
    customIconforAssignedBus();
    checkBusAssignedto();
    print(widget.bus_num);
    print(widget.conID);
    print(widget.compId);
    listenToBusLocations();
  }

  BitmapDescriptor movingbusMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor assignedBusMArker = BitmapDescriptor.defaultMarker;
  String iconLocation = "";
  var helper = BusFunc();
  String? busNumCopy;

  // void storetoCopy(){
  //   setState(() {
  //     busNumCopy = widget.bus_num;
  //   });
  // }



  void checkBusAssignedto() async {
    print('executed');
    if (widget.bus_num == '') {
      FirebaseFirestore.instance
          .collection('ilugan_mobile_users')
          .doc(widget.conID)
          .get()
          .then((DocumentSnapshot userDoc) {
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>; 
          setState(() {
            widget.bus_num = userData['inbus'];
          });
          print(widget.bus_num);
          print(userData);
        } else {
          print("Document does not exist");
        }
      }).catchError((error) {
        print("Error fetching document: $error");
      });
    } else {
      print('has value');
      return;
    }
  }

  void customIconforMovingBuses() {
  BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(
      size: Size(2, 2), // Reduce the size here
      devicePixelRatio: 2.5, // Adjust for better scaling
    ),
    "assets/images/icons/moving_bus_icon.png",
  ).then((icon) {
    setState(() {
      movingbusMarker = icon;
    });
    print(movingbusMarker.toString());
  }).catchError((error) {
    print("Error loading custom icon: $error");
  });
}


  void customIconforAssignedBus() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(2, 2)),
            "assets/images/icons/inbus.png")
        .then((icon) {
      setState(() {
        assignedBusMArker = icon;
      });
      print(assignedBusMArker.toString());
    }).catchError((error) {
      print("Error loading custom icon: $error");
    });
  }

  Set<Marker> markers = {};

  void listenToBusLocations() async {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.compId)
        .collection('buses')
        .snapshots()
        .listen((snapshot) {
      markers.removeWhere((marker) => marker.markerId.value.startsWith('bus_'));
      GeoPoint assignedBusCoordinates;

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (doc.id == widget.bus_num) {
          GeoPoint geoPoint = data['current_location'];
          assignedBusCoordinates = geoPoint;
          String busNumber = data['bus_number'];
          String plateNumber = data['plate_number'];

          LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
          getAssignedBus(position, busNumber, plateNumber);
        } else {
          GeoPoint geoPoint = data['current_location'];
          GeoPoint destination = data['destination_coordinates'];
          String busNumber = data['bus_number'];
          String plateNumber = data['plate_number'];

          LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
          LatLng city_destination =
              LatLng(destination.latitude, destination.longitude);

          // Fetch distance and estimated time asynchronously
          helper.reverseGeocode(position.latitude, position.longitude).then((address){
            helper.getDistance(position, city_destination).then((distance) {
            helper
                .getEstimatedTime(position, city_destination)
                .then((estimatedTime) {
              markers.add(
                Marker(
                  markerId: MarkerId('bus_${doc.id}'),
                  position: position,
                  infoWindow: InfoWindow(
                    title: 'Bus $busNumber',
                    snippet:
                        'Distance: $distance Estimated Time: $estimatedTime \n ',
                  ),
                  icon: movingbusMarker,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                  'Distance: $distance \nEstimated Time: $estimatedTime \nAddress: $address'),
                            ));
                  },
                ),
              );
              setState(() {}); // Update the UI to reflect new markers
            });
          });
        });
        }
      }
    });
  }

  late GoogleMapController mapController;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void getAssignedBus(LatLng busloc, String busNum, String plateNum) {
    markers.removeWhere(
        (marker) => marker.markerId.value == 'assignedbus_location');
    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: busloc,
        infoWindow: const InfoWindow(title: 'Assigned Bus'),
        icon: assignedBusMArker,
      ),
    );
    setToLocation(busloc);
    // });
  }

  void setToLocation(LatLng position) {
    print('panned to location');
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 20);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
              target: LatLng(15.975949534874196, 120.57135500752592), zoom: 12),
          mapType: MapType.normal,
          onMapCreated: (controller) {
            mapController = controller;
          },
          markers: markers,
        ),
      );
  }
}
