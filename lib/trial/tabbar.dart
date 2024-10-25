import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Top Nav Example"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Screen 1"),
              Tab(text: "Screen 2"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ScreenOne(), // The first screen
            ScreenTwo(), // The second screen
          ],
        ),
      ),
    );
  }
}

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This is Screen 1"),
    );
  }
}

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This is Screen 2"),
    );
  }
}
