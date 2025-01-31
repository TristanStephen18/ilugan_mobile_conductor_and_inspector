// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/choosebus.dart';
// import 'package:iluganmobile_conductors_and_inspector/conductor/helpers.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/firebase_helpers/auth.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/homescreen_ins.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // searchUsers();
  }

  final formkey = GlobalKey<FormState>();
  var emailcon = TextEditingController();
  var passcon = TextEditingController();

  String? commpId;
  String? name;
  String? user_email;
  String? type;
  String? conId;
  String? status;
  String? inbus;
  String? userid;

  Future<bool> searchUsers(email, password) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ilugan_mobile_users')
          .get();

      var docs = querySnapshot.docs;

      for (var doc in docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['email'] == email) {
          userid = doc.id;
          user_email = data['email'];
          commpId = data['companyId'];
          name = data['employee_name'];
          type = data['type'];
          conId = data['id'];
          status = data['status'];
          inbus = data['inbus'];
          break;
        }
      }
    } catch (e) {
      print('Error searching users: $e');
    }
    return false;
  }

  void checklogin() async {
    if (formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: "Processing",
        title: "Signing you in",
      );
      await searchUsers(emailcon.text, passcon.text);
      // Conductor().changedstatus('active', commpId.toString());

      if(user_email == null){
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "There is no such email",
          title: "Oops",
        );
      }else if(user_email != null&& status == 'disabled'){
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "This account has been disabled",
          title: "Account Info",
        );
      }else if(inbus == ""){
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "You have not been assigned to any bus yet",
          title: "Log in Info",
        );
      }else{
        await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailcon.text, password: passcon.text)
          .then((UserCredential cred) async {
        Navigator.of(context).pop();
        if(type == 'conductor'){
          await Auth().onBusChosen(commpId.toString(), FirebaseAuth.instance.currentUser!.uid);
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Dashboard_Con(compId: commpId.toString(), bus_num: inbus, conID: conId)));
          // Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>ChooseBusScreen(compId: commpId as String, conductorId: cred.user!.uid, conname: name as String,)));
        }else{
          await Auth().oninspectorlogin(commpId as String, FirebaseAuth.instance.currentUser!.uid);
          Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>Dashboard_Ins(compId: commpId as String,)));
        }
      }).catchError((error) {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: error.toString(),
          title: "Oops",
        );
      });
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.redAccent,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        title: CustomText(content: 'ILugan', fsize: 
        30, fontcolor: Colors.white, fontweight: FontWeight.w500,),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // child: SingleChildScrollView(
            child: Form(
              key: formkey, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  CustomText(
                    content: "Log In",
                    fsize: 30,
                    fontcolor: Colors.black,
                    fontweight: FontWeight.bold,
                  ),
                  const Gap(10),
                  CustomText(
                    content: "Kindly Log in your company issued account.",
                    fsize: 16,
                    fontcolor: Colors.black,
                    
                  ),
                  const Gap(100),
                  CustomText(content: "Email", fontcolor: Colors.black,),
                  const Gap(5),
                  LoginTfields(field_controller: emailcon, label: "e.g employee@email.com", suffixicon: Icons.email,),
                  const Gap(20),
                  CustomText(content: "Password", fontcolor: Colors.black,),
                  const Gap(5),
                  LoginPassTfields(field_controller: passcon, showpassIcon: Icons.visibility, hidepassIcon: Icons.visibility_off, showpass: true),
                  const SizedBox(height: 200),
                  Center(
                    child: Ebuttons(func: checklogin, label: "Log In", bcolor: Colors.green, fcolor: Colors.white, width: MediaQuery.sizeOf(context).width/1.3, height: 70, tsize: 25,)
                  ),
                  const Gap(70),
                ],
              ),
            ),
          // ),
        ),
      ),
    );
  }
}
