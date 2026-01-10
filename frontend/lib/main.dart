import 'package:flutter/material.dart';
import 'splash/splash_screen.dart';
import 'auth/login_screen.dart';




import 'package:frontend/home_shell.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/home_shell.dart';


void main(){
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const SplashScreen(),
    );
  }
}
