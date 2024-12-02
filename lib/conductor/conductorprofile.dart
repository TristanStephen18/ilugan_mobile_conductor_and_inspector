import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class ProfileCon extends StatefulWidget {
   ProfileCon({super.key, required this.companyId,});

  String companyId;

  @override
  State<ProfileCon> createState() => _ProfileConState();
}

class _ProfileConState extends State<ProfileCon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: CustomText(
          content: 'Conductor'.toUpperCase(),
          fsize: 20,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
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
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(future: FirebaseFirestore.instance.collection('companies').doc(widget.companyId).collection('employees').doc(FirebaseAuth.instance.currentUser!.uid).get(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

           var userData = snapshot.data!.data() as Map<String, dynamic>;

           return SingleChildScrollView(
            child: Padding(padding: EdgeInsets.all(20), 
            child: Column(
              children: [
                const Center(
                  child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/icons/dp.png'),
                      radius: 60,
                    ),
                ),
                const Gap(70),
                ProfileTfields(
                    label: 'Username',
                    data: userData['employee_name'].toString(),
                    prefix: const Icon(Icons.person, color: Colors.black),
                  ),
                  const Gap(20),
                  ProfileTfields(
                    label: 'Employee ID',
                    prefix: const Icon(Icons.verified, color: Colors.black),
                    data: userData['id'].toString(),
                  ),
                  const Gap(20),
                  ProfileTfields(
                    label: 'Email',
                    prefix: const Icon(Icons.mail, color: Colors.black),
                    data: userData['email'].toString(),
                  ),
                  const Gap(20),
                  ProfileTfields(
                    label: 'Status',
                    data: userData['status'].toString(),
                    prefix: const Icon(Icons.person_pin_circle_sharp, color: Colors.black),
                  ),
              ],
            ),
            ),
           );
      }),
    );
  }
}