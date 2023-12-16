import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:garagesale/src/feature/BrowsePost.dart';
import 'package:garagesale/src/feature/Home.dart';
import 'package:garagesale/src/util/MyButton.dart';
import 'package:garagesale/src/util/Settings.dart';

/// New user register page.
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static const String id = 'register_page';

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: AssetImage('images/applogo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(color: Colors.white),
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Enter Your Email',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                style: TextStyle(color: Colors.white),
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Enter Your Password',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyButton(
                color: Colors.redAccent,
                text: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    // Create user with firebase auth and proceed to browse post page
                    await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    Navigator.pushNamed(context, BrowsePost.id);
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              MyButton(
                color: Colors.lightBlueAccent,
                text: 'Back',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    Navigator.pushNamed(context, Home.id);
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}