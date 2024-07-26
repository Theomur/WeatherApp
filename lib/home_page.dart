// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:weather_app/location_dialog.dart';

String location = 'Санкт-Петербург';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void locationEnter() {
    showDialog(
      context: context,
      builder: (context) {
        return SelectLocation();
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
              onTap: locationEnter,
              child: Center(child: Text(location)),
            )),
        body: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Text("Env.apikey"),
            ),
          ],
        ));
  }
}
