import 'package:egresso_ifpi/controllers/drawer_controller.dart';
import 'package:egresso_ifpi/controllers/user_controller.dart';
import 'package:egresso_ifpi/ui/app/app.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt getIt = GetIt.I;
  getIt.registerLazySingleton(() => DrawerPageController());
  getIt.registerLazySingleton(() => Utils());
  getIt.registerLazySingleton(() => UserController());

  runApp(App());
}
