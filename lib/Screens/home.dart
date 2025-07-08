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

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String error = '';
  bool load = true;

  void initState() {
    super.initState();
    func();
  }

  func() async {
    final fetchedExpenses = await _auth.getExpenses(user);
    setState(() {
      expenses = fetchedExpenses;
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? Loading()
        : Scaffold(
          backgroundColor: Color(0xFFF2ECD8),
          appBar: AppBar(
            toolbarHeight: 150,
            backgroundColor: Color(0xFFF2ECD8),
            title: Text(
              'TRACK',
              style: TextStyle(
                fontFamily: 'MyFont',
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontSize: 50,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(-20.0), // height of the line
              child: Container(
                width: 200,
                color: Colors.black, // line color
                height: 5.0,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.power_settings_new_rounded),
                color: Colors.black,
                iconSize: 55,
                onPressed: () {
                  setState(() {
                    user = '';
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                // give space for the button
                child: ListView(
                  children:
                      expenses
                          .map(
                            (info) => ExpCard(
                              info: info,
                              onDelete: () async {
                                String? result = await _auth.delete(
                                  info.id!,
                                  user,
                                );
                                if (result == null) {
                                  setState(() {
                                    expenses.removeWhere(
                                      (e) => e.id == info.id,
                                    );
                                  });
                                }
                              },
                              onEdit: ()async{
                                setState(() {
                                  objid=info.id!;
                                });
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => update()),
                                );
                                await func();
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      elevation: 0.0,
                      backgroundColor: Colors.black,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Add()),
                        );
                        setState(() {
                        });
                      },
                      child: Icon(Icons.add, color: Colors.white, size: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
