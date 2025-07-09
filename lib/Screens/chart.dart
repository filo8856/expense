import 'package:expense1/Screens/add.dart';
import 'package:expense1/Screens/update.dart';
import 'package:expense1/Screens/auth.dart';
import 'package:expense1/Screens/expenselist.dart';
import 'package:expense1/Screens/authenticate.dart';
import 'package:expense1/Screens/card_class.dart';
import 'package:expense1/Screens/exp_card.dart';
import 'package:expense1/Screens/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense1/loading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:col,
      appBar:AppBar(backgroundColor:col
      ),
    );
  }
}
