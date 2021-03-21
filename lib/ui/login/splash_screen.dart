import 'package:egresso_ifpi/ui/home/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    nextPage() {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return Home();
        }));
      });
    }

    nextPage();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                strokeWidth: 2,
              ),
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
