import 'package:flutter/material.dart';
import 'package:resepmakanan_5b/ui/home_screen.dart';
import 'package:resepmakanan_5b/ui/login_screen.dart';
import 'package:resepmakanan_5b/ui/register_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/register',
      routes: {
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}