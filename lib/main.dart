import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theologia_app_1/categorypage/categorypage.dart';
import 'package:theologia_app_1/home/home.dart';
import 'package:theologia_app_1/nav/nav.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.crimsonText(
            fontSize: 48
          ),
          headlineMedium: GoogleFonts.crimsonText(
            fontSize: 24)
        )
      ),
      routerConfig: appRouter
    );
  }
}
 