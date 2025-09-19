import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_tabs.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  String texto = "texto inicial 🟢";
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
        "🟢 initState() -> La pantalla se ha inicializado con el widget Tabbar",
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (kDebugMode) {
      print(
        "🟡 didChangeDependencies() -> Tema actual: Gridview. Se actualizó con el metodo Go. No hay vista a la que volver",
      );
    }
  }

  /// Se ejecuta cuando el widget es eliminado de la memoria.
  @override
  void dispose() {
    if (kDebugMode) {
      print(
        "🔴 dispose() -> La pantalla se ha destruido con el metodo Go, ya que no hay vista a la que volver con .pop() se devuelve con .go()",
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to the Details Page',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
