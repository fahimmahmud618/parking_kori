import 'package:flutter/material.dart';

class ParkOut extends StatefulWidget {
  const ParkOut({super.key});

  @override
  State<ParkOut> createState() => _ParkOutState();
}

class _ParkOutState extends State<ParkOut> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Text("park out"),
      ),
    ));
  }
}
