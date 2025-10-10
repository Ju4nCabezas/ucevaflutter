import 'package:flutter/material.dart';

class AppTheme {
  //! tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 20, 83, 165),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 39, 156, 68),
              width: 3,
            ),
          ),
        ),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      drawerTheme: const DrawerThemeData(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 20, 83, 165),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 20, 83, 165),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
