import 'package:flutter/material.dart';
import '../home_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard Principal')),
        body: const HomePage(),
      ),
    );
  }
}
