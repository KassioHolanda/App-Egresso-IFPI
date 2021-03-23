import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/ui/home/home_screen.dart';
import 'package:egresso_ifpi/ui/login/register_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginScreen extends StatelessWidget {
  final loginController = LoginController();
  final _scafoldkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    message(String message) {
      _scafoldkey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        behavior: SnackBarBehavior.floating,
        duration: new Duration(seconds: 5),
      ));
    }

    nextPage() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
    }

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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder()),
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return 'Email não pode ficar em branco.';
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Senha',
                                    border: OutlineInputBorder()),
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
                    color: Colors.red[400],
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
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return RegisterUserScreen();
                      }));
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Observer(
                  builder: (_) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: !loginController.utils.loading
                            ? Colors.green[400]
                            : Colors.green[100],
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loginController.utils.loading
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Container(
                                    width: 0,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Entrar',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        onPressed: !loginController.utils.loading
                            ? () async {
                                if (_formKey.currentState.validate()) {
                                  await loginController.loginComEmail(
                                      emailController.text,
                                      passwordController.text,
                                      message,
                                      nextPage);
                                }
                              }
                            : null,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
