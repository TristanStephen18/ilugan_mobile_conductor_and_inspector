// ignore_for_file: avoid_print, use_super_parameters, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key, required this.companyId, required this.busnum});

  final busnum;
  final companyId;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: CustomText(
          content: 'Emergency Alert',
          fsize: 17,
          fontcolor: Colors.yellowAccent,
          fontweight: FontWeight.w500,
        ),
        actions: const [
          Image(
            image: AssetImage("assets/images/logo.png"),
            height: 50,
            width: 50,
          ),
        ],
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            CategoryCard(
              label: 'Accidents',
              imagePath: 'assets/images/icons/busaccidents.png',
              busnum: widget.busnum,
              companyId: widget.companyId,
            ),
            CategoryCard(
              label: 'Medical',
              imagePath: 'assets/images/icons/medical.png',
              busnum: widget.busnum,
              companyId: widget.companyId,
            ),
            CategoryCard(
              label: 'Mechanical',
              imagePath: 'assets/images/icons/meechanical.png',
              busnum: widget.busnum,
              companyId: widget.companyId,
            ),
            CategoryCard(
              label: 'Others',
              imagePath: 'assets/images/icons/others.png',
              busnum: widget.busnum,
              companyId: widget.companyId,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final String label;
  final String imagePath;
  final String companyId;
  final String busnum;

  const CategoryCard(
      {Key? key,
      required this.label,
      required this.imagePath,
      required this.companyId,
      required this.busnum})
      : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  void alertcompany() async {
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .collection('busalerts')
          .doc()
          .set({
        "emergency": widget.label,
        "busnumber": widget.busnum,
        "description": _controller.text
      }).then((value){
        QuickAlert.show(context: context, type: QuickAlertType.info, title: "Alert Sent");
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Describe the ${widget.label} emergency"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter description",
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: alertcompany,
                  child: const Text(
                    "Send",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePath,
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
