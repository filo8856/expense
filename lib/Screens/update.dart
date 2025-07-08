import 'package:expense1/Screens/auth.dart';
import 'package:expense1/Screens/expenselist.dart';
import 'package:expense1/Screens/home.dart';
import 'package:expense1/Screens/card_class.dart';
import 'package:expense1/Screens/global.dart';
import 'package:expense1/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class update extends StatefulWidget {
  const update({super.key});

  @override
  State<update> createState() => _updateState();
}

class _updateState extends State<update> {
  final AuthService _auth = AuthService();
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
  String formDesc = '';
  String id = '';
  double formAmount = 0.0;
  String error = '';
  TextEditingController formDate = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return load
        ? Loading()
        : Scaffold(
      backgroundColor: Color(0xFFF2ECD8),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 50),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        toolbarHeight: 150,
        backgroundColor: Color(0xFFF2ECD8),
        title: Text(
          'EDIT',
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
            icon: Icon(Icons.save),
            color: Colors.black,
            iconSize: 55,
            onPressed: () async{
              String? result=await _auth.edit(formDesc, formCat,formAmount, DateFormat('dd.MM.yy').parse(formDate.text), user,objid);
              if(result!=null)
                setState(() {
                  error='Couldnt create';
                });
              else
              {
                setState(() {
                  expenses.removeWhere(
                        (e) => e.id == objid,
                  );
                });
                objid='';
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
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
                            child: Icon(Icons.calendar_today,size: 20,),
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
                  ],
                ),
                SizedBox(height: 40),
                TextFormField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Description',
                    hintStyle: TextStyle(
                      fontSize: 20,
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
                  onChanged: (val) {
                    setState(() {
                      formDesc = val.trim();
                    });
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.currency_rupee),
                    hintText: 'Amount',
                    hintStyle: TextStyle(
                      fontSize: 20,
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
                      (val) =>
                  val == null
                      ? 'Please select a category'
                      : null,
                  onChanged: (val) {
                    setState(() {
                      formAmount=double.parse(val);
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
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
  }
}