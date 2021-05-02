import 'package:egresso_ifpi/ui/home/home_screen.dart';
import 'package:egresso_ifpi/ui/login/login_screen.dart';
import 'package:egresso_ifpi/ui/login/register_user_screen.dart';
import 'package:egresso_ifpi/ui/login/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green[800],
          textTheme: GoogleFonts.sansitaTextTheme(Theme.of(context).textTheme),
          primaryTextTheme: TextTheme(),
          scaffoldBackgroundColor: Colors.grey[100]),
      home: SplashScreen(),
      // routes: {
      //   '/': (context) => SplashScreen(),
      //   '/login': (context) => LoginScreen(),
      //   '/home': (context) => Home(),
      //   '/register': (context) => RegisterUserScreen(),
      // },
    );
  }
}
