import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';

class SampleScree extends StatelessWidget {
  SampleScree({super.key, required this.compId,required this.bus_num, required this.conID});

  String compId;
  String? bus_num;
  String conID;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: const Text('Back')),
    );
  }
}