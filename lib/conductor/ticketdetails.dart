// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/imageviewer.dart';
import 'package:iluganmobile_conductors_and_inspector/helpers/busfunctions.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
// import 'image_viewer.dart'; // Import the ImageViewer widget

class ReservationDetails extends StatefulWidget {
  ReservationDetails(
      {super.key,
      required this.resnum,
      required this.from,
      required this.to,
      this.idurl,
      required this.type,
      required this.distance,
      required this.fare,
      required this.passID,
      required this.seats});

  String from;
  String to;
  String? idurl;
  String distance;
  double fare;
  String passID;
  int seats;
  String resnum;
  String type;

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  CameraPosition? position;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    initializedata();
  }

  void initializedata() async {
    LatLng? fromcoordinates = await BusFunc().getCoordinates(widget.from);
    LatLng? tocoordinates = await BusFunc().getCoordinates(widget.to);

    if (fromcoordinates != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: fromcoordinates,
          infoWindow: const InfoWindow(title: "Pick up location"),
        ),
      );
    }
    if (tocoordinates != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: tocoordinates,
          infoWindow: const InfoWindow(title: "Destination"),
        ),
      );
    }
    setState(() {
      position = CameraPosition(
          target: LatLng(fromcoordinates!.latitude, fromcoordinates.longitude),
          zoom: 11);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: CustomText(
          content: 'Reservation# ${widget.resnum}',
          fontcolor: Colors.white,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: position != null
          ? Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: position as CameraPosition,
                  markers: markers,
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (widget.idurl != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewer(
                                              imageUrl: widget.idurl!),
                                        ),
                                      );
                                    }
                                  },
                                  child: widget.idurl != null
                                      ? Image.network(
                                          widget.idurl!,
                                          width: 120,
                                          height: 120,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Text(
                                                      'Failed to load ID image.'),
                                          loadingBuilder: (context, child,
                                              progress) {
                                            if (progress == null) return child;
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              value: progress.expectedTotalBytes !=
                                                      null
                                                  ? progress.cumulativeBytesLoaded /
                                                      progress.expectedTotalBytes!
                                                  : null,
                                            ));
                                          },
                                        )
                                      : const Image(
                                          image: AssetImage(
                                              'assets/images/icons/dp.png'),
                                          height: 80,
                                          width: 80,
                                        ),
                                ),
                                const Gap(10),
                                Column(
                                  children: [
                                    CustomText(
                                      content: 'ID: ${widget.passID}',
                                      fsize: 10,
                                      fontweight: FontWeight.bold,
                                    ),
                                    const Divider(color: Colors.black, thickness: 2,),
                                    const Gap(5),
                                    CustomText(content: 'Type: ${widget.type}'),
                                    Row(
                                      children: [
                                        CustomText(
                                            content:
                                                'Distance: ${widget.distance}'),
                                        const Gap(10),
                                        CustomText(
                                            content:
                                                'Fare: ${widget.fare} php'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CustomText(
                                content:
                                    'Pick up location: ${widget.from.toUpperCase()}'),
                            CustomText(
                                content:
                                    'Destination: ${widget.to.toUpperCase()}'),
                          ],
                        ),
                      ),
                    ))
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
