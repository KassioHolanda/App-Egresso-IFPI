import 'package:egresso_ifpi/ui/home/home_screen.dart';
import 'package:egresso_ifpi/ui/login/splash_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green,
          scaffoldBackgroundColor: Colors.grey[100]),
      home: Home(),
    );
  }
}
