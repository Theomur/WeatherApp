// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:weather_app/pages/location_dialog.dart';

String Location = 'Moscow, Russia';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void ChangeLocation_AppBar(String newLocation) {
    List<String> cityCountry = newLocation.split(',');
    setState(() {
      Location = "${cityCountry[0]},${cityCountry[2]}";
    });
  }

  void LocationEnterPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return SelectLocation(
          ChangeLocationFunction: ChangeLocation_AppBar,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        elevation: 10,
        title: GestureDetector(
          onTap: LocationEnterPopUp,
          child: Center(child: Text(Location, style: TextStyle(fontSize: 20))),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 100,
            width: 300,
            child: Center(child: Text("")),
          ),
        ],
      ),
    );
  }
}
