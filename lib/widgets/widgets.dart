import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Appdrawers extends StatelessWidget {
  Appdrawers({
    super.key,
    required this.logoutfunc
    });

  VoidCallback logoutfunc;

  @override
  Widget build(BuildContext context) {
    return Drawer(   
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Column(

              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                    children: [
                      Gap(36),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/icons/conductor_icon.png'),
                        radius: 50,
                      ),
                      Column(
                        children: [
                          Text('Name/ID'  ),
                          Text('Role')
                        ],
                      )
                    ],
                    ),
                  ),
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              title: Text('Log out'),
              onTap: logoutfunc,
            ),
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


//sample code for bottomnavigation bar
class BotNavBar4Conductor extends StatefulWidget {
  const BotNavBar4Conductor({super.key});

  @override
  State<BotNavBar4Conductor> createState() => _BotNavBar4ConductorState();
}

class _BotNavBar4ConductorState extends State<BotNavBar4Conductor> {

  int currentpageindex= 0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);  
    return Scaffold(
      appBar: AppBar(),
      drawer: Appdrawers(logoutfunc: (){},),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          setState(() {
            currentpageindex = index;
          });
        },
        indicatorColor: Colors.green,
        selectedIndex: currentpageindex,
        destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.map_sharp),
              icon: Icon(Icons.home_outlined),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.qr_code_scanner)),
              label: 'Scanner',
            ),
            NavigationDestination(
              icon: Badge(
                child: Icon(Icons.list_alt_rounded),
              ),
              label: 'Reservations',
            ),
          ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Maps Page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][currentpageindex],
    );
  }
}

class Texts extends StatelessWidget {
  Texts({
    super.key,
    required this.content,
    this.color,
    this.fontsize,
    this.weight
  });
  String content = "";
  Color? color = Colors.white;
  FontWeight? weight = FontWeight.normal;
  double? fontsize = 15;

  @override
  Widget build(BuildContext context) {
    return Text(
      content, 
      style: GoogleFonts.inter(
        fontSize: fontsize,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
