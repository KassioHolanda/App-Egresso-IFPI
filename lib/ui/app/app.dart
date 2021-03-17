import 'package:egresso_ifpi/ui/login/login.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green,
          scaffoldBackgroundColor: Colors.grey[100]),
      home: LoginScreen(),
    );
  }
}
