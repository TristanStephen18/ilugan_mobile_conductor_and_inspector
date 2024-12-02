

// ignore_for_file: avoid_print

import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

String apiKeyDistance = '32OQ6PekD6m1FLGbx3KHHIF21E7sRGpuk9CU3urbZMsDPzaCvDTfTuqjaS2o24fF';
const String apiKey = "pk.f2d90e157115e9c3410ae4e890cd0f50";

//apikey = pk.b1172a5bd0a53f7260d0cca6f5ebb71a
class BusFunc {
  
  // final apiKey = "pk.e6e28e751bd0e401a2a07cb0cbe2e6e4";
  // final apiKeyDistance = 'plpzSXk6wsl0A0OsQxHT4VUJLvCQUHaOaYRuqsieIdc5pswMo6aIeSm5r6eHyynp';
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
  // String time= "";
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
      print(response.body);
      return "Address not available";
    }
  } catch (error) {
    print("Error fetching address: $error");
    return "Address not available";
  }
}

Future<LatLng?> getCoordinates(String address) async {
  final String encodedAddress = Uri.encodeComponent(address);
  LatLng? coordinates;
  print('fetching response from api');

  final String url =
      "https://us1.locationiq.com/v1/search?key=${apiKey}&q=${encodedAddress}&format=json";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Access the first result in the array
      if (data is List && data.isNotEmpty) {
        final firstResult = data[0];
        coordinates = LatLng(
          double.parse(firstResult['lat']),
          double.parse(firstResult['lon']),
        );
        print(coordinates);
        return coordinates;
      } else {
        print("No results found for the address.");
        return null;
      }
    } else {
      print("Error: Received status code ${response.statusCode}");
      return null;
    }
  } catch (error) {
    print("Error fetching address: $error");
    return null;
  }
}


// Future<Map<String, dynamic>> getrealtimeupdates(){
  
// }
}