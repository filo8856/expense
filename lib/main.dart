import 'package:flutter/material.dart';
import 'package:expense1/Screens/wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(), // This must be a child of MaterialApp
    );
  }
}
