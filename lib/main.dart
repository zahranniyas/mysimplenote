import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_simple_note/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MySimpleNote',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(color: Colors.black87),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: HomeScreen(),
    );
  }
}