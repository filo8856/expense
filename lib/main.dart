import 'package:expense1/Screens/global.dart';
import 'package:flutter/material.dart';
import 'package:expense1/Screens/wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await loadUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}
