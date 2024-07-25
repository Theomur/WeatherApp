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
          backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
          elevation: 10,
          title: GestureDetector(
            onTap: locationEnter,
            child: Center(child: Text(location)),
          )),
    );
  }
}
