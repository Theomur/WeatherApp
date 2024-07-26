// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustumButton extends StatelessWidget {
  VoidCallback OnPressed;
  CustumButton({super.key, required this.OnPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: OnPressed,
      color: Theme.of(context).colorScheme.primaryFixed,
      elevation: 5,
      child: Text("OK"),
    );
  }
}
