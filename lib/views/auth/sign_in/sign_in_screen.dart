import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Center(
            child: Text("Sign In Screen",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}
