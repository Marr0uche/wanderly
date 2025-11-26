import 'package:flutter/material.dart';
import 'screens/accueil_screen.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeVM.currentTheme, // <-- ici le mode change automatiquement
      home: const AccueilScreen(),
    );
  }
}
