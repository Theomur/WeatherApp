import 'package:flutter/material.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
      content: SizedBox(
          height: 200,
          width: 300,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Выберете местоположение',
              style: TextStyle(fontSize: 20),
            ),
          )),
    );
  }
}
