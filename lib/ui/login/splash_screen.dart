import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/ui/home/home_screen.dart';
import 'package:egresso_ifpi/ui/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    loginUser() async {
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
    }

    loginPage() async {
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen();
      }));
    }

    // nextPage();

    return Scaffold(
      body: Container(
        // width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Container(
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                            strokeWidth: 2,
                          ),
                          width: 20,
                          height: 20,
                        )
                      ],
                    ),
                  ),
                );
              default:
                return Center(
                    child: Container(
                  width: 80,
                  height: 80,
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ));
            }
          },
          future: loginController.isLoggedIn(loginUser, loginPage),
        ),
      ),
    );
  }
}
