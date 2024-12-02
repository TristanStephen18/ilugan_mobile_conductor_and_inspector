// ignore_for_file: use_build_context_synchronously, must_be_immutable, camel_case_types, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/firebase_helpers/auth.dart';
import 'package:iluganmobile_conductors_and_inspector/firebase_helpers/fetching.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/busfunctions.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/displayer.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
// import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

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
    _loadCustomMarkers();
    // customIcon();
    listenToBusLocations();
    getCurrentLocation();
    getuserdata();
  }

  String email = "";
  String name = "";
  String id = "";
  String companyId = "";
  String? comapnyname;
  LatLng? currentloc;

  Future<void> getuserdata() async {
    var data = await Data().getEmployeeData(widget.compId);
    if (mounted) {
      // setState(() {
      // });

      // getBusRealtimeData(companyId.toString(), busNum.toString());
      String? cname = await Data().getcompanyname(widget.compId);
      if (mounted) {
        setState(() {
          email = data?['email'];
          name = data?['name'];
          id = data?['id'];
          // busNum = data?['inbus'];
          companyId = data?['companyid'];
          comapnyname = cname;
        });

        // await Auth().oninspectorlogin(widget.compId, id);
      }
    }
  }

  // void customIcon() {
  //   BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(20, 20)),
  //     "assets/images/icons/bicon.png"
  //   ).then((icon) {
  //     setState(() {
  //       markerIcon = icon;
  //     });
  //   }).catchError((error) {
  //     print("Error loading custom icon: $error");
  //   });
  // }

  // void showbusinfo(buscompany, busnumber, currentlocation, available, occupied, reserved){
  // ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15)
  //       ),
  //       behavior: SnackBarBehavior.fixed,
  //       backgroundColor: Color.fromARGB(255, 226, 91, 82),
  //       content: Padding(
  //           padding: const EdgeInsets.all(0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               const Gap(10),
  //               Row(
  //                 children: [
  //                   const Image(
  //                   height: 100,
  //                   width: 150,
  //                   image: AssetImage('assets/images/icons/inbus.png')),
  //                   const Gap(10),
  //                   Column(
  //                     children: [
  //                       Text(
  //                         buscompany,
  //                         style: GoogleFonts.inter(
  //                         textStyle: const TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                         )
  //                       ),
  //                     ),
  //                     Text(
  //                       busnumber,
  //                       style: GoogleFonts.inter(
  //                           textStyle: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.w500,
  //                           )
  //                         ),
  //                     ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const Gap(10),
  //               Text(currentlocation, style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 15
  //               ),),
  //               const Gap(20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     children: [
  //                       const Text('Available seats'),
  //                       const Gap(10),
  //                       Container(
  //                         height: 70,
  //                         width: 70,
  //                         decoration: const BoxDecoration(
  //                           color: Color.fromARGB(255, 54, 150, 42)
  //                         ),
  //                         child: Center(
  //                           child: Text(available.toString(), style: const TextStyle(
  //                             fontSize: 35
  //                           ),),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Column(
  //                     children: [
  //                       const Text('Occupied'),
  //                       const Gap(10),
  //                       Container(
  //                         height: 70,
  //                         width: 70,
  //                         decoration: const BoxDecoration(
  //                           color: Color.fromARGB(255, 0, 0, 0)
  //                         ),
  //                         child: Center(
  //                           child: Text(occupied.toString(), style: const TextStyle(
  //                             fontSize: 35
  //                           ),),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Column(
  //                     children: [
  //                       const Text('Reserved'),
  //                       const Gap(10),
  //                       Container(
  //                         height: 70,
  //                         width: 70,
  //                         decoration: const BoxDecoration(
  //                           color: Color.fromARGB(255, 148, 150, 42)
  //                         ),
  //                         child: Center(
  //                           child: Text(reserved.toString(), style: const TextStyle(
  //                             fontSize: 35
  //                           ),),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const Gap(20),
  //               OutlinedButton(onPressed: (){
  //                 // Navigator.of(context).pop();
  //                 // Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>BDetailsScreen()));
  //               },
  //               style: OutlinedButton.styleFrom(
  //                 backgroundColor: Colors.white,
  //                 foregroundColor: Colors.black,
  //                 fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
  //               ),
  //               child: const Text('View Bus', style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold
  //               ),),

  //               )
  //             ],
  //           ),
  //         ),
  //       )
  //   );
  // }

  void listenToBusLocations() {
    FirebaseFirestore.instance
        .collection('companies')
        .doc(widget.compId)
        .collection('buses')
        .snapshots()
        .listen((snapshot) async {
      markers.removeWhere((marker) => marker.markerId.value.startsWith('bus_'));

      for (var doc in snapshot.docs) {
        var data = doc.data();
        print(doc.data());
        String busNumber = data['bus_number'] ?? '';

        String plateNumber = data['plate_number'] ?? '';
        int availableSeats = data['available_seats'] ?? 0;
        int occupiedSeats = data['occupied_seats'] ?? 0;
        int reservedSeats = data['reserved_seats'] ?? 0;
        GeoPoint geoPoint = data['current_location'] ?? const GeoPoint(0, 0);
         GeoPoint geoPointd = data['destination_coordinates'] ?? const GeoPoint(0, 0);
        LatLng currentLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
        LatLng destinationLocation = LatLng(geoPointd.latitude, geoPointd.longitude);

        String locationaddress = await BusFunc().reverseGeocode(currentLocation.latitude, currentLocation.longitude);

        // LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
        // BusFunc()
        //     .reverseGeocode(position.latitude, position.longitude)
        //     .then((address) {
          markers.add(
            Marker(
              markerId: MarkerId('bus_${doc.id}'),
              position: currentLocation,
              onTap: () {
                print(address);
                // Format the GeoPoint as a meaningful string
                // String currentLocation =
                //     "Lat: ${geoPoint.latitude}, Lon: ${geoPoint.longitude}";

                DisplayItems().showBusInfoDialog(
                  context,
                    'Dagupan Bus Inc.',
                    busNumber,
                    plateNumber,
                    locationaddress,
                    availableSeats,
                    occupiedSeats,
                    reservedSeats,
                    destinationLocation,
                    currentLocation,
                    widget.compId
                    );

                // Call the showbusinfo function from BusFunc
                // showbusinfo(
                //   'Dagupan Bus',  // Company ID
                //   busNumber,      // Bus number
                //   address, // Formatted location
                //   availableseats, // Available seats
                //   occupied,       // Occupied seats
                //   reserved
                //   );
              },
              icon: assignedBusMarker,
            ),
          );
          setState(() {});
        // });
      } // Trigger UI update
    });
  }

  BitmapDescriptor movingbusMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor assignedBusMarker = BitmapDescriptor.defaultMarker;

  Future<void> _loadCustomMarkers() async {
    try {
      movingbusMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.2),
        "assets/images/icons/movingbus.bmp",
      );
      assignedBusMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 4.5),
        "assets/images/icons/mbus.bmp",
      );
      if (mounted) {
        setState(() {}); // Update the UI with loaded markers
      }
    } catch (e) {
      print("Error loading custom icons: $e");
    }
  }

  String? address;

  void getcurrentlocationaddress(LatLng position) async {
    String? add =
        await BusFunc().reverseGeocode(position.latitude, position.longitude);

    setState(() {
      address = add;
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
      // markers.removeWhere((marker) => marker.markerId.value == 'user_location');
      // markers.add(
      //   Marker(
      //     markerId: const MarkerId('user_location'),
      //     position: currentPosition,
      //     infoWindow: const InfoWindow(title: 'You are here'),
      //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //   ),
      // );
      getcurrentlocationaddress(currentPosition);
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
        const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')),
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
        const SnackBar(
            content: Text('Location permission permanently denied.')),
      );
      return false;
    }
    return true;
  }

  void logout() async {
    await Auth().oninspectorlogout(
        widget.compId, FirebaseAuth.instance.currentUser!.uid);
    await FirebaseAuth.instance.signOut().then((val) async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    if(address == null){
      getCurrentLocation();
    }

    return SafeArea(
      child: Scaffold(
        drawer: InsAppdrawers(
          logoutfunc: logout,
          compID: companyId,
          insid: id,
          insname: name,
        ),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 60,
          title: CustomText(
            content:
                comapnyname != null ? comapnyname.toString() : 'Loading...',
            fsize: 20,
            fontcolor: Colors.white,
            fontweight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: const [
            Image(
              image: AssetImage("assets/images/logo.png"),
              height: 50,
              width: 50,
            ),
            Gap(10)
          ],
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(15.975949534874196, 120.57135500752592),
                  zoom: 15,
                ),
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  mapController = controller;
                },
                markers: markers,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
              Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: address != null ? Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_pin),
                              CustomText(content: 'Currently at')
                            ],
                          ),
                          const Gap(10),
                          CustomText(
                            content: address.toString(),
                            fontweight: FontWeight.w800,
                          ),
                        ],
                      ) : const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
