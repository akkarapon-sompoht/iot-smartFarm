import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/components/background.dart';
import 'package:project/welome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Background(child: WelcomePage(),)
    );
  }
}
