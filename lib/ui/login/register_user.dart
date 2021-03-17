import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:flutter/material.dart';

class RegisterUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginController = LoginController();

    final _scafoldkey = GlobalKey<ScaffoldState>();
    final _formKey = GlobalKey<FormState>();

    Widget textForm(String label) {
      return TextFormField(
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar usuário'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              textForm('Nome'),
              SizedBox(height: 10),
              textForm('Email'),
              SizedBox(height: 10),
              textForm('CPF'),
              SizedBox(height: 10),
              textForm('Data nascimento'),
              SizedBox(height: 10),
              textForm('Matrícula'),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.red[300],
                ),
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  child: Text(
                    'Continuar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // await loginController
                      //     .loginComEmail(
                      //         emailController.text, passwordController.text)
                      //     .then((value) {
                      //   Navigator.of(context).push(
                      //       MaterialPageRoute(builder: (BuildContext context) {
                      //     return Home();
                      //   }));
                      // }).catchError((error) {
                      //   _scafoldkey.currentState.showSnackBar(SnackBar(
                      //     content: Text(
                      //       error.toString(),
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold, fontSize: 14),
                      //     ),
                      //     behavior: SnackBarBehavior.floating,
                      //     duration: new Duration(seconds: 3),
                      //   ));
                      // });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
