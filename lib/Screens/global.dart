import 'dart:ui';

import 'package:expense1/Screens/card_class.dart';
import 'package:expense1/Screens/expenselist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = FlutterSecureStorage();
String user='';
Future<void> loadUser() async {
  String? temp = await storage.read(key: 'user');
  if (temp != null) {
    user = temp;
  }
}
String objid='';
Color col=Color(0xFFF2ECD8);
//Color(0xFFF2ECD8)
