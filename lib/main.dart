import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:securevideo/pages/Home/homescreen.dart';
import 'package:securevideo/pages/welcome_screen/welcome_screen.dart';
import 'package:securevideo/test/testscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure-Video',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
    );
  }
}
