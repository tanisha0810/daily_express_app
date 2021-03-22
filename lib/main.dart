import 'package:flutter/material.dart';
import 'package:news_app/views/scaffold/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Express',
      theme: ThemeData(
        primaryColor: Color(0xffb60f1d),
        accentColor: Color(0xff0FB6A9),
        fontFamily: 'OpenSans',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
