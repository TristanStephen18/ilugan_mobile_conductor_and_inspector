import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/seatverification.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
import 'package:status_alert/status_alert.dart';

class DisplayItems {
  void showBusInfoDialog(
  BuildContext context,
  String buscompany,
  String busnumber,
  String platenumber,
  String currentlocation,
  int availableseats,
  int occupied,
  int reserved,
  LatLng destinationcoordinates,
  LatLng buslocation,
  String compid
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Bus Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: const Text('X', style: TextStyle(
                      fontSize: 20
                    ),))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Image(
                      height: 80,
                      width: 100,
                      image: AssetImage('assets/images/icons/choose.png'),
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buscompany.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          busnumber,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Currently at:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  currentlocation,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Route',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.directions, color: Colors.black),
                        Text(
                          'Cubao',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Text(
                      '---------------------->',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        Text(
                          'Dagupan',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Seating Info',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSeatInfoColumn('Available', availableseats,
                        const Color.fromARGB(255, 60, 172, 45)), // Green
                    _buildSeatInfoColumn('Occupied', occupied,
                        const Color.fromARGB(255, 70, 134, 43)), // Red
                    _buildSeatInfoColumn('Reserved', reserved,
                        const Color.fromARGB(255, 0, 0, 0)), // Yellow
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SeatverificationScreen(compid: compid, busid: platenumber)));
                      // // if (availableseats == 0) {
                      // //   StatusAlert.show(
                      // //     context,
                      // //     title: 'Bus is fully occupied',
                      // //     configuration: const IconConfiguration(
                      // //         icon: Icons.bus_alert_outlined, color: Colors.red),
                      // //     duration: const Duration(seconds: 1),
                      // //   );
                      // // } else if (hasreservation) {
                      // //   StatusAlert.show(
                      // //     context,
                      // //     title: 'You already have a reservation',
                      // //     configuration: const IconConfiguration(
                      // //         icon: Icons.error, color: Colors.red),
                      // //     duration: const Duration(seconds: 1),
                      // //   );
                      // } else {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (_) => SelectLocationScreen(
                        //     companyId: companyId,
                        //     compName: buscompany,
                        //     busnum: platenumber,
                        //     currentloc: currentloc,
                        //     destinationloc: destinationcoordinates,
                        //     currentlocation: buslocation,
                        //   ),
                        // ));
                      // }
                    },
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: CustomText(content: 'Verify Seats', fontcolor: Colors.white, fontweight: FontWeight.bold, fsize: 20,)
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildSeatInfoColumn(String label, int count, Color color) {
  return Column(
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 5),
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}

}



// class UserDataGetter{
//   String getusername(){
//     String username = "";
//     User? user = FirebaseAuth.instance.currentUser;

    

//     return username;
//   }
// }
