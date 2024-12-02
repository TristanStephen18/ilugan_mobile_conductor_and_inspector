import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusViewer extends StatefulWidget {
  const BusViewer({super.key, required this.busnum, required this.compId});

  final String busnum;
  final String compId;

  @override
  State<BusViewer> createState() => _BusViewerState();
}

class _BusViewerState extends State<BusViewer> {

  @override
  void initState() {
    super.initState();
    print(widget.compId);
    print(widget.busnum);
    _getBusinfo();
    _loadCustomMarkers();
  }

  LatLng? current_location;
  String? conductor;
  Set<Marker> markers = {};
  late GoogleMapController mapController;
  String? address;

  BitmapDescriptor? markericon;


Future<void> _loadCustomMarkers() async {
    try {
      markericon = await BitmapDescriptor.fromAssetImage(
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


  void setToLocation(LatLng position) {
    CameraPosition cameraPosition = CameraPosition(target: position, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  void _getBusinfo() {
  FirebaseFirestore.instance
      .collection('companies')
      .doc(widget.compId)
      .collection('buses')
      .doc(widget.busnum)
      .snapshots()
      .listen((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
  
      // Check if 'current_location' is a GeoPoint
      GeoPoint geoPoint = data['current_location'] as GeoPoint;
      LatLng newLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
      print(newLocation);

      // Update markers and camera position
      markers.add(Marker(
        markerId: MarkerId('busloc'),
        position: newLocation,
        infoWindow: InfoWindow(title: "Bus Location"),
        icon: markericon as BitmapDescriptor
      ));

      setToLocation(newLocation);
      setState(() {
        current_location = newLocation;
      });
    } else {
      print('Document Data does not exist');
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title:  Text(widget.busnum, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Image(
              image: AssetImage("assets/images/logo.png"),
              height: 50,
              width: 50,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: GoogleMap(
        initialCameraPosition:
            const CameraPosition(target: LatLng(15.975900821755888, 120.57068659548693)),
        mapType: MapType.normal,
        onMapCreated: (controller) => mapController = controller,
        markers: markers,
      )),
    );
  }
}
