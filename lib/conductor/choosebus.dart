import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';

class ChooseBusScreen extends StatefulWidget {
  ChooseBusScreen({
    super.key,
    required this.compId,
    required this.conductorId,
    required this.conname
  });

  String compId = "";
  String conductorId = "";
  String conname;

  @override
  State<ChooseBusScreen> createState() => _ChooseBusScreenState();
}

class _ChooseBusScreenState extends State<ChooseBusScreen> {
  String? selectedBus;
  List<String> busNumbers = [];
  String? choice = "";

  @override
  void initState() {
    super.initState();
    fetchBusNumbers();
  }

  void assigntobus(String? bus_num){
  FirebaseFirestore.instance
      .collection('companies')    
      .doc(widget.compId)               
      .collection('buses')        
      .doc(choice)                
      .update({
        'conductor': widget.conname,  
      }).then((_) {
        print("Bus conductor updated successfully!");
      }).catchError((error) {
        print("Failed to update bus conductor: $error");
      });
    FirebaseFirestore.instance.collection('ilugan_mobile_users').doc(widget.conductorId).update(
      {
        'inbus' : choice
      }
    ).then((_) {
        print("User Conductor updated successfully!");
      }).catchError((error) {
        print("Failed to update user location: $error");
      });
  }

  Future<void> fetchBusNumbers() async {
    try {
      QuerySnapshot busesSnapshot = await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.compId)
          .collection('buses')
          .get();

      List<String> fetchedBusNumbers =
          busesSnapshot.docs.map((doc) => doc.id.toString()).toList();

      setState(() {
        busNumbers = fetchedBusNumbers;
      });
      
    } catch (e) {
      print('Error fetching bus numbers: $e');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Bus'),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: busNumbers.isEmpty
            ? const CircularProgressIndicator() 
            : Column(
                children: [
                  DropdownButton<String>(
                    value: selectedBus,
                    hint: const Text('Select Bus Number'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBus = newValue;
                        choice = selectedBus;
                      });
                    },
                    items: busNumbers.map((String busNumber) {
                      return DropdownMenuItem<String>(
                        value: busNumber,
                        child: Text(busNumber),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(onPressed: () {
                    assigntobus(choice);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Dashboard_Con(compId: widget.compId, bus_num: choice,)));
                  }, child: const Text('Next'))
                ],
              ),
      ),
    );
  }
}
