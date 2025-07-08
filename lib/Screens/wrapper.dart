import 'package:expense1/Screens/add.dart';
import 'package:expense1/Screens/global.dart';
import 'package:flutter/material.dart';
import 'package:expense1/Screens/authenticate.dart';
import 'package:expense1/Screens/home.dart';
class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //return Home or Auth
    if(user=='')
    {
      return Authenticate();
    }
    else
      return Home();
  }
}
