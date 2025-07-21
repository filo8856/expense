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
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool check = false;
  bool filter = false;
  String error = '';
  bool load = true;
  List<Exp> copy = [];
  final storage = FlutterSecureStorage();
  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Other',
  ];

  Icon _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icon(Icons.restaurant);
      case 'transport':
        return Icon(Icons.directions_car);
      case 'shopping':
        return Icon(Icons.shopping_bag);
      case 'entertainment':
        return Icon(Icons.movie);
      case 'bills':
        return Icon(Icons.receipt);
      case 'other':
        return Icon(Icons.question_mark);
      default:
        return Icon(Icons.category);
    }
  }

  String? selectCat;
  String formCat = '';
  double tot = 0;
  TextEditingController formDate = TextEditingController();

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
      copy = fetchedExpenses;
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
            actions: [
              IconButton(
                icon: Icon(Icons.filter_alt),
                color: Colors.black,
                iconSize: 55,
                onPressed: () {
                  setState(() {
                    filter = !filter;
                  });
                  Filter();
                },
              ),
            ],
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
                        IconButton(
                          icon: Icon(Icons.person, size: 120,color:Colors.black,),
                          onPressed: () async {
                            // if (user == 'satvik') {
                            //   setState(() {
                            //     user = '';
                            //     load = true;
                            //   });
                            // } else {
                            //   setState(() {
                            //     user = 'satvik';
                            //     load = true;
                            //   });
                            // }
                            // await func();
                            // setState(() {
                            //   load = false;
                            // });
                          },
                        ),
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
                        SizedBox(height: 10),
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.pie_chart_rounded,
                        //     color: Colors.grey[800],
                        //     size: 35,
                        //   ),
                        //   title: Text(
                        //     'Budget',
                        //     style: TextStyle(
                        //       fontFamily: 'MyFont',
                        //       fontWeight: FontWeight.w900,
                        //       color: Colors.black,
                        //       fontSize: 27,
                        //     ),
                        //   ),
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => Chart()),
                        //     );
                        //   },
                        // ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: Icon(
                            Icons.logout_rounded,
                            // color: Colors.grey[800],
                            color: Colors.black,
                            size: 40,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'MyFont',
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                          onTap: () async {
                            await storage.write(key: 'user', value: '');
                            setState(() {
                              user = '';
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Authenticate(),
                              ),
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
          body: Column(
            children: [
              if (filter)
                Container(
                  //height: 70,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              value: selectCat,
                              icon: const SizedBox.shrink(),
                              isExpanded: true,
                              items:
                                  categories.map((String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectCat = newValue!;
                                  formCat = newValue;
                                });
                                Filter();
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: _getCategoryIcon(formCat),
                                labelText: 'Category',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value == null
                                          ? 'Please select a category'
                                          : null,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: formDate,
                              readOnly: true,
                              onTap: () {
                                _formD();
                              },
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: SizedBox(
                                  width: 5,
                                  child: Icon(Icons.calendar_today, size: 20),
                                ),
                                labelText: 'Date',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                formDate.clear();
                                selectCat = null;
                                formCat = '';
                              });
                              Filter();
                            },
                            icon: Icon(
                              Icons.refresh,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            'Total:',
                            style: TextStyle(
                              fontFamily: 'MyFont',
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    '₹$tot',
                                    style: TextStyle(
                                      fontFamily: 'MyFont',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Month:  ',
                            style: TextStyle(
                              fontFamily: 'MyFont',
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          Transform.scale(
                            scale: 2,
                            child: Checkbox(
                              checkColor: Colors.black,
                              activeColor: Colors.white,
                              side: BorderSide(width: 1, color: Colors.black),
                              value: check,
                              onChanged: (bool? value) {
                                setState(() {
                                  check = value!;
                                });
                                Filter();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: ListView(
                        children:
                            filter
                                ? (copy
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
                                              builder:
                                                  (context) =>
                                                      update(info: info),
                                            ),
                                          );
                                          await func();
                                          setState(() {
                                            load = false;
                                            filter = false;
                                          });
                                        },
                                      ),
                                    )
                                    .toList())
                                : (expenses
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
                                          Filter();
                                        },
                                        onEdit: () async {
                                          setState(() {
                                            objid = info.id!;
                                            load = true;
                                          });
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      update(info: info),
                                            ),
                                          );
                                          await func();
                                          setState(() {
                                            load = false;
                                          });
                                        },
                                      ),
                                    )
                                    .toList()),
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
                                filter = false;
                                load = false;
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  Future<void> _formD() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (_picked != null) {
      setState(() {
        formDate.text = DateFormat('dd.MM.yy').format(_picked);
      });
    }
    Filter();
  }

  void Filter() {
    if (selectCat != null && formDate.text.isNotEmpty) {
      DateTime selectedDate = DateFormat('dd.MM.yy').parse(formDate.text);
      if (check) {
        setState(() {
          copy =
              expenses
                  .where(
                    (e) =>
                        selectCat == e.cat &&
                        e.date.month == selectedDate.month &&
                        e.date.year == selectedDate.year,
                  )
                  .toList();
        });
      } else {
        setState(() {
          copy =
              expenses
                  .where(
                    (e) =>
                        selectCat == e.cat &&
                        e.date.day == selectedDate.day &&
                        e.date.month == selectedDate.month &&
                        e.date.year == selectedDate.year,
                  )
                  .toList();
        });
      }
    } else if (selectCat != null) {
      setState(() {
        copy = expenses.where((e) => selectCat == e.cat).toList();
      });
    } else if (formDate.text.isNotEmpty) {
      DateTime selectedDate = DateFormat('dd.MM.yy').parse(formDate.text);
      if (check) {
        setState(() {
          copy =
              expenses
                  .where(
                    (e) =>
                        e.date.month == selectedDate.month &&
                        e.date.year == selectedDate.year,
                  )
                  .toList();
        });
      } else {
        setState(() {
          copy =
              expenses
                  .where(
                    (e) =>
                        e.date.day == selectedDate.day &&
                        e.date.month == selectedDate.month &&
                        e.date.year == selectedDate.year,
                  )
                  .toList();
        });
      }
    } else {
      setState(() {
        copy = expenses;
      });
    }
    setState(() {
      tot = copy.fold(0.0, (sum, e) => sum + e.amount);
    });
  }
}
