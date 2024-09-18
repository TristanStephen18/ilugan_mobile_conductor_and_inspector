import 'package:flutter/material.dart';

class Appdrawers extends StatelessWidget {
  Appdrawers({
    super.key,
    required this.logoutfunc
    });

  VoidCallback logoutfunc;

  @override
  Widget build(BuildContext context) {
    return Drawer(   
      backgroundColor: Colors.green,
      child: ListView(
        children: [
          DrawerHeader(
            child: const Text('Ilugan')
          ),
          // Divider(height: 2,),
          ListTile(
            title: Text('Log out'),
            onTap: logoutfunc,
          )
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      ''
    );
  }
}