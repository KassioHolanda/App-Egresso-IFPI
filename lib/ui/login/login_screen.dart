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
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
    }

    _dialogEsqueciSenha() {
      showDialog(
          context: context,
          builder: (_) {
            final emailController = TextEditingController();
            final formKey = GlobalKey<FormState>();

            return AlertDialog(
              title: Text(
                'Esqueci minha senha',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Informe seu Email para recuperar sua senha'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        validator: (text) {
                          if (text.isEmpty || text.length == 0) {
                            return 'Email obrigatório';
                          }
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText:
                                'Informe seu email para recuperar sua senha')),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              actions: [
                FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      await loginController
                          .recuperarSenhaUsuario(emailController.text);

                      message('Link de alteração foi enviado ao seu email.');
                      Navigator.of(context).pop();
                    }
                  },
                  child:
                      Text('Recuperar', style: TextStyle(color: Colors.white)),
                ),
                FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('Cancelar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          });
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
                                    hintText: 'Email',
                                    fillColor: Colors.white.withOpacity(0.6),
                                    filled: true,
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
                                    hintText: 'Senha',
                                    fillColor: Colors.white.withOpacity(0.6),
                                    filled: true,
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
                          onPressed: () {
                            _dialogEsqueciSenha();
                          },
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
                    color: Colors.red,
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
                    onPressed: () async {
                      // await Future.delayed(Duration(seconds: 1));
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
                            ? Colors.green
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
