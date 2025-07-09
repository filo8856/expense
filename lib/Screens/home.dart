import 'package:expense1/Screens/add.dart';
import 'package:expense1/Screens/chart.dart';
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

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String error = '';
  bool load = true;
  final storage = FlutterSecureStorage();
  double calculateMonthlyTotal(List<Exp> expenses) {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

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
    final double monthlyTotal = calculateMonthlyTotal(expenses);
    return load
        ? Loading()
        : Scaffold(
          backgroundColor: col,
          appBar: AppBar(
            leading: Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, size: 60),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
            ),
            toolbarHeight: 150,
            backgroundColor: col,
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
            // actions: [
            //   IconButton(
            //     icon: Icon(Icons.power_settings_new_rounded),
            //     color: Colors.black,
            //     iconSize: 55,
            //     onPressed: () async {
            //       await storage.write(key: 'user', value: '');
            //       setState(() {
            //         user = '';
            //       });
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(builder: (context) => Authenticate()),
            //       );
            //     },
            //   ),
            // ],
          ),
          drawer: SizedBox(
            width: 270,
            child: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: col,
                    child: Column(
                      children: [
                        SizedBox(height: 70),
                        Icon(Icons.person, size: 120),
                        Text(
                          textAlign: TextAlign.center,
                          user,
                          style: TextStyle(
                            fontFamily: 'MyFont',
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(26),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          'Monthly Expense\n₹$monthlyTotal\n',
                          style: TextStyle(
                            fontFamily: 'MyFont',
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(height:10),
                        ListTile(
                          leading: Icon(
                            Icons.pie_chart_rounded,
                            color: Colors.grey[800],
                            size: 35,
                          ),
                          title: Text(
                            'Budget',
                            style: TextStyle(
                              fontFamily: 'MyFont',
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 27,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Chart()),
                            );
                          },
                        ),
                        SizedBox(height:10),
                        ListTile(
                          leading: Icon(
                            Icons.logout_rounded,
                            color: Colors.grey[800],
                            size: 35,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'MyFont',
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 27,
                            ),
                          ),
                          onTap: ()async {
                            await storage.write(key: 'user', value: '');
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
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: ListView(
                  children:
                      expenses
                          .map(
                            (info) => ExpCard(
                              info: info,
                              onDelete: () async {
                                setState(() {
                                  load = true;
                                });
                                String? result = await _auth.delete(
                                  info.id!,
                                  user,
                                );
                                if (result == null) {
                                  setState(() {
                                    expenses.removeWhere(
                                      (e) => e.id == info.id,
                                    );
                                    load = false;
                                  });
                                }
                              },
                              onEdit: () async {
                                setState(() {
                                  objid = info.id!;
                                  load = true;
                                });
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => update(info: info),
                                  ),
                                );
                                await func();
                                setState(() {
                                  load = false;
                                });
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
                        setState(() {
                          load = true;
                        });
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Add()),
                        );
                        await func();
                        setState(() {
                          load = false;
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
