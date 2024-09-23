import 'package:flutter/material.dart';
import 'package:iluganmobile_conductors_and_inspector/conductor/homescreen_con.dart';
import 'package:iluganmobile_conductors_and_inspector/widgets/widgets.dart';

class ConductorScreens extends StatefulWidget {
  ConductorScreens({super.key, required this.companyId,required this.busnum, required this.conId});

  String companyId;
  String busnum;
  String conId;

  @override
  State<ConductorScreens> createState() => _ConductorScreensState();
}

class _ConductorScreensState extends State<ConductorScreens> {

  int currentpageindex= 0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);  
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
          ],
        ),
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
          Dashboard_Con(compId: widget.companyId, bus_num: widget.busnum, conID: widget.conId),
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
      ),
    );
  }
}