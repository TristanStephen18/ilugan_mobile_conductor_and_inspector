// ignore_for_file: must_be_immutable

// import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/busviewer.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/holderfile.dart';

class Appdrawers extends StatelessWidget {
  Appdrawers(
      {super.key,
      required this.logoutfunc,
      required this.conid,
      required this.coname,
      required this.compID,
      required this.busnum
      });

  VoidCallback logoutfunc;
  String coname;
  String conid;
  String compID;
  String busnum;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Gap(20),
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/icons/conductor_icon.png'),
                                  radius: 50,
                                ),
                                const Gap(20),
                                Column(
                                  children: [
                                    CustomText(
                                      content: coname.toUpperCase(),
                                      fontcolor: Colors.white,
                                      fsize: 20,
                                      fontweight: FontWeight.bold,
                                    ),
                                    CustomText(
                                      content: conid.toUpperCase(),
                                      fontcolor: Colors.white,
                                      fontweight: FontWeight.w600,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
                ListTile(
                  title: CustomText(
                    content: 'Reservations',
                    fontcolor: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  leading: const Icon(
                    Icons.list,
                    color: Colors.red,
                  ),
                  hoverColor: Colors.red,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ReservationsScreen(busnum: busnum, companyId: compID, conId: conid,)));
                  },
                ),
                const Divider(),
                ListTile(
                  title: CustomText(
                    content: 'Buses',
                    fontcolor: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  leading: const Icon(
                    Icons.bus_alert,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BusesScreen(busnum: busnum, compId: compID,)));
                  },
                  hoverColor: Colors.green,
                ),
                const Divider(),
                ListTile(
                  title: CustomText(
                    content: 'Profile',
                    fontcolor: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  hoverColor: Colors.green,
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const TransactionHistoryScreen()));
                  },
                ),
              ],
            ),
          ),
          ListTile(
            onTap: logoutfunc,
            title: CustomText(
              content: 'Log Out',
              fontcolor: const Color.fromARGB(255, 104, 103, 103),
            ),
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            hoverColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  CustomText(
      {super.key,
      required this.content,
      this.fontcolor,
      this.fontweight,
      this.fsize});

  String content;
  Color? fontcolor;
  FontWeight? fontweight;
  double? fsize;

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: GoogleFonts.inter(
          color: fontcolor, fontWeight: fontweight, fontSize: fsize),
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
  int currentpageindex = 0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      // drawer: Appdrawers(logoutfunc: (){},),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
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
  Texts(
      {super.key,
      required this.content,
      this.color,
      this.fontsize,
      this.weight});
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

class Ebuttons extends StatelessWidget {
  Ebuttons(
      {super.key,
      required this.func,
      required this.label,
      this.fcolor,
      this.bcolor,
      this.fontweight,
      this.width,
      this.height,
      this.tsize
      });

  final VoidCallback func;
  String label;
  Color? bcolor;
  Color? fcolor;
  FontWeight? fontweight;
  double? width;
  double? height;
  double? tsize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: ElevatedButton.styleFrom(
        elevation: 10,
          backgroundColor: bcolor,
          fixedSize: Size(width as double, height as double)),
      child: CustomText(
        content: label,
        fontcolor: fcolor,
        fontweight: fontweight,
        fsize: tsize,
      ),
    );
  }
}

class LoginTfields extends StatelessWidget {
  LoginTfields({
    super.key,
    required this.field_controller,
    this.suffixicon,
    this.label,
    this.prefix,
  });

  var field_controller = TextEditingController();
  IconData? suffixicon;
  String? label = "";
  Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: field_controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
          prefix: prefix,
          fillColor: Colors.transparent,
          filled: true,
          suffixIcon: Icon(
            suffixicon,
            color: Colors.black,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          errorStyle: const TextStyle(color: Colors.black)),
    );
  }
}

class LoginPassTfields extends StatefulWidget {
  LoginPassTfields({
    super.key,
    required this.field_controller,
    required this.showpassIcon,
    required this.hidepassIcon,
    required this.showpass,
  });

  var field_controller = TextEditingController();
  IconData? showpassIcon;
  IconData? hidepassIcon;
  bool showpass;

  @override
  State<LoginPassTfields> createState() => _LoginPassTfieldsState();
}

class _LoginPassTfieldsState extends State<LoginPassTfields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.field_controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill up this field';
        }
        return null;
      },
      obscureText: widget.showpass,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  widget.showpass = !widget.showpass;
                });
              },
              icon: Icon(
                widget.showpass ? widget.hidepassIcon : widget.showpassIcon,
                color: Colors.black,
              )),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          errorStyle: const TextStyle(color: Colors.black)),
    );
  }
}
