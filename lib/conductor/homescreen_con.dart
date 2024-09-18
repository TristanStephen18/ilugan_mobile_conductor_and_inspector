import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/busfunctions.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

// ignore: camel_case_types
class Dashboard_Con extends StatefulWidget {
  Dashboard_Con({
    super.key,
    required this.compId,
    required this.bus_num
    });

  String compId;
  String? bus_num;

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
    listenToBusLocations();
  }
   BitmapDescriptor movingbusMarker = BitmapDescriptor.defaultMarker;
   BitmapDescriptor assignedBusMArker = BitmapDescriptor.defaultMarker;
   String iconLocation = "";

  void customIconforMovingBuses() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)), 
      "assets/images/icons/moving_bus_icon.png"
    ).then((icon) {
      setState(() {
        movingbusMarker = icon;
      });
      print(movingbusMarker.toString());
    }).catchError((error) {
      print("Error loading custom icon: $error");
    });
    // return movingbusMarker;
  }

  void customIconforAssignedBus() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)), 
      "assets/images/icons/inbus.png"
    ).then((icon) {
      setState(() {
        assignedBusMArker = icon;
      });
      print(assignedBusMArker.toString());
    }).catchError((error) {
      print("Error loading custom icon: $error");
    });
    // return movingbusMarker;
  }



  Set<Marker> markers = {};

  void listenToBusLocations() {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.compId)
        .collection('buses')
        .snapshots()
        .listen((snapshot) {
      markers.removeWhere((marker) => marker.markerId.value.startsWith('bus_'));

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if(doc.id == widget.bus_num){
        GeoPoint geoPoint = data['current_location'];
        String busNumber = data['bus_number'];
        String plateNumber = data['plate_number'];

        LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
        getAssignedBus(position, busNumber, plateNumber);
        }else{
        GeoPoint geoPoint = data['current_location'];
        String busNumber = data['bus_number'];
        String plateNumber = data['plate_number'];

        LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
        markers.add(
          Marker(
            markerId: MarkerId('bus_${doc.id}'),
            position: position,
            infoWindow: InfoWindow(
              title: 'Bus $busNumber',
              snippet: 'Plate: $plateNumber',
            ),
            icon: movingbusMarker,
            onTap: (){
              BusFunc().showbusinfo(context, "buscompany", "busnumber", "currentlocation", 1, 1, 1);
            }
          ),
        );
        }
      }
      setState(() {}); 
    });
  }

  late GoogleMapController mapController;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const LoginScreen()));
  }

  void getAssignedBus(LatLng busloc, String busNum, String plateNum){
      markers.removeWhere((marker) => marker.markerId.value == 'assignedbus_location');
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
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 20);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {}); 
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Appdrawers(logoutfunc: logout,),
      appBar: AppBar(

      ),
      body: SafeArea(
        child: GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(15.975949534874196, 120.57135500752592), zoom: 12),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: markers,
          ),
      ),
    );
  }
}