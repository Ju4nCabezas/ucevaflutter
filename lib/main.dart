import 'package:flutter/material.dart';
import 'app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Taller Flutter',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
