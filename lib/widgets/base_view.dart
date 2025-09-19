import 'package:flutter/material.dart';
import 'custom_tabs.dart'; // Importa el Drawer personalizado

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseView({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          // Barra horizontal fija
          const CustomMenuBar(),
          const Divider(height: 1), // línea separadora
          // Contenido de la vista
          Expanded(child: body),
        ],
      ),
    );
  }
}
