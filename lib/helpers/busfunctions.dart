

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
class BusFunc {
//  final BuildContext context = BuildContext(); 
 ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showbusinfo(BuildContext context, String buscompany, String busnumber, String currentlocation, int availableseats, int occupied, int reserved){
    print('info');
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