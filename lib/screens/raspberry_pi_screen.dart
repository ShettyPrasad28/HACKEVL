import 'package:flutter/material.dart';

class RaspberryPiScreen extends StatelessWidget {
  const RaspberryPiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raspberry Pi Connection"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "This is where Raspberry Pi connection logic will go.\n"
          "You can implement Bluetooth/Wi-Fi communication here.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
