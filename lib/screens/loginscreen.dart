import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/choosebus.dart';
import 'package:iluganmobile_conductors_and_inspector/inspector_screens/homescreen_ins.dart';
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

  var commpId = null;
  var name = null;
  String user_email = "";
  var type = null;
  var conId = null;

  Future<bool> searchUsers(email, password) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ilugan_mobile_users')
          .get();

      var docs = querySnapshot.docs;

      for (var doc in docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['email'] == email) {
          user_email = data['email'];
          commpId = data['companyId'];
          name = data['employee_name'];
          type = data['type'];
          conId = data['id'];
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

      if(user_email.isEmpty){
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "There is no such email",
          title: "Oops",
        );
      }else{
        await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailcon.text, password: passcon.text)
          .then((UserCredential cred) async {
        Navigator.of(context).pop();
        if(type == 'conductor'){
          Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>ChooseBusScreen(compId: commpId, conductorId: cred.user!.uid, conname: name,)));
        }else{
          Navigator.of(context).push(CupertinoPageRoute(builder: (_)=>Dashboard_Ins(compId: commpId,)));
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
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: const [
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Image(image: AssetImage("assets/images/logo.png")),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                const Gap(20),
                const Text(
                  "Welcome to Ilugan! Kindly Log in your company issued account!",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const Gap(40),
                const Text("Email"),
                const Gap(5),
                TextFormField(
                  controller: emailcon,
                  decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const Gap(20),
                const Text("Password"),
                const Gap(5),
                TextFormField(
                  controller: passcon,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const Gap(50),
                Center(
                  child: ElevatedButton(
                    onPressed: checklogin,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.sizeOf(context).width / 2, 50),
                    ),
                    child: const Text("Log In"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
