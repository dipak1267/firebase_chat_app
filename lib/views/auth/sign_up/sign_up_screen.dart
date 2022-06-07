import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Center(
            child: Text("Sign Up Screen",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}
