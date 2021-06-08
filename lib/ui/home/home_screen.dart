import 'package:egresso_ifpi/controllers/login_controller.dart';
import 'package:egresso_ifpi/ui/config/drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerConfig(),
      appBar: AppBar(
        title: Text('Pagina Inicial'),
      ),
      body: Container(
        child: Center(
          child: Text('Bem vindo ao Egresso IFPI'),
        ),
      ),
    );
  }
}
