// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/busfunctions.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class Dashboard_Ins extends StatefulWidget {
  Dashboard_Ins({super.key, required this.compId});

  String compId;

  @override
  State<Dashboard_Ins> createState() => _Dashboard_InsState();
}

class _Dashboard_InsState extends State<Dashboard_Ins> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  Set<Marker> markers = {}; 
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    customIcon();
    listenToBusLocations();
    getCurrentLocation();
  }

  void customIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)), 
      "assets/images/icons/moving_bus_icon.png"
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    }).catchError((error) {
      print("Error loading custom icon: $error");
    });
  }

  void showbusinfo(buscompany, busnumber, currentlocation, available, occupied, reserved){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Color.fromARGB(255, 226, 91, 82),
        content: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(10),
                Row(
                  children: [
                    const Image(
                    height: 100,
                    width: 150,
                    image: AssetImage('assets/images/icons/inbus.png')),
                    const Gap(10),
                    Column(
                      children: [
                        Text(
                          buscompany,
                          style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      Text(
                        busnumber,
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )
                          ),
                      ),
                      ],
                    ),
                  ],
                ),
                const Gap(10),
                Text(currentlocation, style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
                ),),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text('Available seats'),
                        const Gap(10),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 54, 150, 42)
                          ),
                          child: Center(
                            child: Text(available.toString(), style: const TextStyle(
                              fontSize: 35
                            ),),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Occupied'),
                        const Gap(10),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 0, 0)
                          ),
                          child: Center(
                            child: Text(occupied.toString(), style: const TextStyle(
                              fontSize: 35
                            ),),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Reserved'),
                        const Gap(10),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 148, 150, 42)
                          ),  
                          child: Center(
                            child: Text(reserved.toString(), style: const TextStyle(
                              fontSize: 35
                            ),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                OutlinedButton(onPressed: (){
                  // Navigator.of(context).pop();
                  // Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>BDetailsScreen()));
                }, 
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                ),
                child: const Text('View Bus', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),

                )
              ],
            ),
          ),
        )
    );
  }

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
      GeoPoint geoPoint = data['current_location'];
      String busNumber = data['bus_number'];
      String plateNumber = data['plate_number'];
      int availableseats = data['available_seats'];
      int occupied = data['occupied_seats'];
      int reserved = data['reserved_seats'];

      LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
      BusFunc().reverseGeocode(position.latitude, position.longitude).then((address) {
        markers.add(
        Marker(
          markerId: MarkerId('bus_${doc.id}'),
          position: position,
          onTap: () {
            // Format the GeoPoint as a meaningful string
            String currentLocation =
                "Lat: ${geoPoint.latitude}, Lon: ${geoPoint.longitude}";

            // Call the showbusinfo function from BusFunc
            showbusinfo(
              'Dagupan Bus',  // Company ID
              busNumber,      // Bus number
              address, // Formatted location
              availableseats, // Available seats
              occupied,       // Occupied seats
              reserved
              );
          },
          icon: markerIcon,
        ),
      );
      setState(() {}); 
      });
    }// Trigger UI update
  });
}

  void getCurrentLocation() async {
    if (!await checkServicePermission()) return;

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    ).listen((position) {
      LatLng currentPosition = LatLng(position.latitude, position.longitude);
      markers.removeWhere((marker) => marker.markerId.value == 'user_location');
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: currentPosition,
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      setToLocation(currentPosition); 
    });
  }

  void setToLocation(LatLng position) {
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {}); 
  }

  Future<bool> checkServicePermission() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them.')),
      );
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission permanently denied.')),
      );
      return false;
    }
    return true;
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Appdrawers(logoutfunc: logout),
        appBar: AppBar(
          title: const Text('Inspector Dashboard'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(15.975949534874196, 120.57135500752592),
              zoom: 15,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: markers,
          ),
        ),
      ),
    );
  }
}
