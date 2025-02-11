import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CelestifyApp());
}

class CelestifyApp extends StatelessWidget {
  const CelestifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Celestify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
