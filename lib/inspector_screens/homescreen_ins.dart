// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

        LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
        markers.add(
          Marker(
            markerId: MarkerId('bus_${doc.id}'),
            position: position,
            infoWindow: InfoWindow(
              title: 'Bus $busNumber',
              snippet: 'Plate: $plateNumber',
            ),
            icon: markerIcon,
          ),
        );
      }
      setState(() {}); 
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
    return Scaffold(
      drawer: Appdrawers(logoutfunc: logout),
      appBar: AppBar(
        title: const Text('Inspector Dashboard'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(15.975949534874196, 120.57135500752592),
            zoom: 12,
          ),
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
