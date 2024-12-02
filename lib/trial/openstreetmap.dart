// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class OpenstreetmapTrial extends StatelessWidget {
//   const OpenstreetmapTrial({super.key});
  
//   get child => null;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(actions: [], title: const Text('OPSMAP Trial'),),
//       body: FlutterMap(
//         // options: MapOptions(
//         //   initialCenter: 
//         // ),
//         children: [
//           maptilelayer,
//           MarkerLayer(markers: {
//             Marker(point: LatLng(15.975550179744682, 120.57072956111321), child: const Icon(Icons.location_pin))
//           })
//       ]),
//     );
//   }
// }

// TileLayer get maptilelayer => TileLayer(
//   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//   userAgentPackageName: 'dev.fleaflet.flutter_map.example',
// );