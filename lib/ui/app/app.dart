import 'package:egresso_ifpi/ui/login/splash.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green,
          scaffoldBackgroundColor: Colors.grey[100]),
      home: SplashScreen(),
    );
  }
}
