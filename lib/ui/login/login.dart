import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/ui/user/home/home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final loginController = LoginController();
  final _scafoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.green[100], Colors.red[100]])),
      child: Scaffold(
        key: _scafoldkey,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // width: 60,
                        // height: 60,
                        child: Image(
                          image: AssetImage('assets/images/ifpilogo.png'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration:
                                      InputDecoration(hintText: 'Email'),
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return 'Email não pode ficar em branco.';
                                    }
                                  },
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(hintText: 'Senha'),
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return 'Senha não pode ficar em branco.';
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            'Esqueci minha senha',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red[300],
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20)),
                    // color: Colors.deepPurple,
                    child: Text(
                      'Criar novo usuário',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.green[300],
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    child: Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        print(
                            '${emailController.text}\n ${passwordController.text}');
                        await loginController
                            .loginComEmail(
                                emailController.text, passwordController.text)
                            .then((value) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Home();
                          }));
                        }).catchError((error) {
                          _scafoldkey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              error.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: new Duration(seconds: 3),
                          ));
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
