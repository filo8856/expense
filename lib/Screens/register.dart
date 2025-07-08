import 'package:expense1/Screens/auth.dart';
import 'package:expense1/Screens/global.dart';
import 'package:expense1/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:expense1/loading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Register extends StatefulWidget {
  final Function toggle;

  const Register({super.key, required this.toggle});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  bool load = false;
  String userid = '';
  String pass = '';
  String error = '';

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
          'SIGNUP',
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
            icon: Icon(Icons.login),
            color: Colors.black,
            iconSize: 55,
            onPressed: () async {
              widget.toggle();
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
                TextFormField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    hintText: 'UserId',
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
                  validator: (val) => val!.isEmpty ? 'Enter UserId' : null,
                  onChanged: (val) {
                    setState(() {
                      userid = val.trim();
                    });
                  },
                ),
                SizedBox(height: 40),
                TextFormField(
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
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
                  val!.length < 6
                      ? "Enter a password 6+ chars long"
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      pass = val;
                    });
                  },
                ),
                SizedBox(height: 50),
                Container(
                  width: 200,
                  height: 60,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        40,
                      ), // round corners
                    ),
                    onPressed: () async {
                      setState(() {
                        load = true;
                      });
                      if (_formkey.currentState!.validate()) {
                        String? result = await _auth.register(userid, pass);
                        if (result != null) {
                          setState(() {
                            load = false;
                            error = result;
                          });
                        }
                        else
                          {
                            await storage.write(key: 'user', value: userid);
                            setState(() {
                              user=userid;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          }
                      } else {
                        setState(() {
                          load = false;
                        });
                      }
                    },
                    child: Text(
                      'SIGNUP',
                      style: TextStyle(
                        fontFamily: 'MyFont',
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    elevation: 0.0,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 15,fontWeight:FontWeight.bold),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
