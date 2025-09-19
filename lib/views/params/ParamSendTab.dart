import 'package:flutter/material.dart';

class ParamSenderTab extends StatefulWidget {
  final ValueChanged<String> onSend;

  const ParamSenderTab({super.key, required this.onSend});

  @override
  State<ParamSenderTab> createState() => _ParamSenderTabState();
}

class _ParamSenderTabState extends State<ParamSenderTab> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Escribe un parámetro",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSend(_controller.text); // manda el parámetro
              DefaultTabController.of(
                context,
              ).animateTo(1); // cambia a tab destino
            },
            child: const Text("Enviar a otra pestaña"),
          ),
        ],
      ),
    );
  }
}
