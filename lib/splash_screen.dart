import 'package:TR/features/home/ui/screen/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:  (context) =>  HomeScreen()));
          },
          child: Text('Go to Home Screen'),
        ),
      ),
    );
  }
}