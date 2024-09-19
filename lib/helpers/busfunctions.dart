

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
class BusFunc {
  final apiKey = "pk.e6e28e751bd0e401a2a07cb0cbe2e6e4";
  final apiKeyDistance = 'KI0g89qwGyjqflqUTyKFFfC3aFub5IPflkx4L9sOkGUxqXXRXpeIpuxNII3GI1pf';
//  final BuildContext context = BuildContext(); 
  Future<String?> getDistance(LatLng origin, LatLng end) async {
  try {
    final response = await http.get(
      Uri.parse(
        'https://api.distancematrix.ai/maps/api/distancematrix/json?origins=${origin.latitude},${origin.longitude}&destinations=${end.latitude},${end.longitude}&key=$apiKeyDistance',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rows'][0]['elements'][0]['distance']['text'];
    } else {
      print('Error fetching distance: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error fetching distance: $error');
    return null;
  }
}



// Function to get estimated time
Future<String?> getEstimatedTime(LatLng origin, LatLng end) async {
  String time= "";
  try {
    final response = await http.get(
      Uri.parse(
        'https://api.distancematrix.ai/maps/api/distancematrix/json?origins=${origin.latitude},${origin.longitude}&destinations=${end.latitude},${end.longitude}&key=$apiKeyDistance',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rows'][0]['elements'][0]['duration']['text'];
    } else {
      print('Error fetching estimated time: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error fetching estimated time: $error');
    return null;
  }
}

Future<String> reverseGeocode(double lat, double lon) async {
  const String apiKey = "pk.e6e28e751bd0e401a2a07cb0cbe2e6e4";
  final String url =
      "https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$lat&lon=$lon&format=json";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name']; // Return the address from the response
    } else {
      return "Address not available";
    }
  } catch (error) {
    print("Error fetching address: $error");
    return "Address not available";
  }
}

 ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showbusinfo(BuildContext context, String buscompany, String busnumber, String currentlocation, int availableseats, int occupied, int reserved){
    return ScaffoldMessenger.of(context).showSnackBar(
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
                Row(
                  children: [
                    Text('Lat:', style: const TextStyle(
                      fontSize: 10
                    ),),
                    const Gap(50),
                    Text('Long:',style: const TextStyle(
                      fontSize: 10
                    ),),
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
                            child: Text(availableseats.toString(), style: const TextStyle(
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
}