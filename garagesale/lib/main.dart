import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:garagesale/firebase_options.dart';
import 'package:garagesale/src/feature/BrowsePost.dart';
import 'package:garagesale/src/feature/Home.dart';
import 'package:garagesale/src/feature/LogOn.dart';
import 'package:garagesale/src/feature/Register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: Home.id,
        routes: {
          BrowsePost.id: (context) => const BrowsePost(),
          Home.id: (context) => const Home(),
          LogOn.id: (context) => const LogOn(),
          Register.id: (context) => const Register(),
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) =>
            const Scaffold(body: Center(child: Text('Not Found'))),
          );
        });
  }
}
