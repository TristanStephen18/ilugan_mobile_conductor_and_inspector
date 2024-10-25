// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/screens/loginscreen.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

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
  List<Map<String, dynamic>> busList = [];  // List to hold bus data (number and conductor)
  String? choice = "";

  @override
  void initState() {
    super.initState();
    fetchBusNumbers();
  }

  void assigntobus() {
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

    FirebaseFirestore.instance.collection('companies').doc(widget.compId).collection('employees').doc(widget.conductorId).
    update(
      {
        'inbus': choice
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

      List<Map<String, dynamic>> fetchedBusList = busesSnapshot.docs.map((doc) {
        return {
          'busNumber': doc.id,
          'conductor': doc['conductor']  // Fetch conductor info for each bus
        };
      }).toList();

      setState(() {
        busList = fetchedBusList;
      });
      
    } catch (e) {
      print('Error fetching bus numbers: $e');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: CustomText(content: 'Conductor', fsize: 
        30, fontcolor: Colors.yellowAccent, fontweight: FontWeight.w500,),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.yellow,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Image(
            image: AssetImage("assets/images/logo.png"),
            height: 50,
            width: 50,
          ),
          Gap(10)
        ],
        backgroundColor: Colors.redAccent,
      ),
      body: busList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: busList.length,
              itemBuilder: (context, index) {
                String busNumber = busList[index]['busNumber'];
                String? conductor = busList[index]['conductor'];
                bool isAssigned = conductor != null && conductor.isNotEmpty;

                return GestureDetector(
                  onTap: isAssigned
                      ? null  // Disable tap if the bus is already assigned
                      : () {
                          setState(() {
                            selectedBus = busNumber;
                            choice = selectedBus;
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isAssigned ? const Color.fromARGB(255, 136, 134, 134) : (selectedBus == busNumber ? Colors.redAccent : Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const Image(image: AssetImage('assets/images/icons/choose.png')),
                          const Spacer(),
                          CustomText(
                            content: busNumber,
                            fontcolor: isAssigned ? Colors.black45 : Colors.black,

                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: selectedBus != null
          ? FloatingActionButton(
              onPressed: () {
                assigntobus();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Dashboard_Con(
                      compId: widget.compId,
                      bus_num: choice,
                      conID: widget.conductorId,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}
