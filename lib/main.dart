import 'package:daily_drive/hidden_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {

  // Initialize the Hive box
  await Hive.initFlutter();

  // Open a box
  await Hive.openBox("Daily_Drive_Database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      //primarySwatch: Colors.deepPurple,
      textTheme: GoogleFonts.openSansTextTheme(),

      // Define your light theme settings here
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      //primarySwatch: Colors.deepPurple,
      textTheme: GoogleFonts.openSansTextTheme(),

      //brightness: Brightness.dark,
      // Define your dark theme settings here
    );

    return MaterialApp(
      title: 'Your App Name',
      theme: lightTheme, // Set the default light theme
      darkTheme: darkTheme, // Set the dark theme
      themeMode: ThemeMode.system, // Allow the app to follow system settings

      home: const HiddenDrawer(),
      debugShowCheckedModeBanner: false,
    );
  }
}