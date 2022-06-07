import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Center(
            child: Text("WELCOME",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}
