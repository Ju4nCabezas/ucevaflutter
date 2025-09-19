import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyGridView extends StatelessWidget {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final methods = [
      'Go (reemplazar el stack)',
      'Push (añadir al stack)',
      'Replace (intercambiar vista actual)',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: methods.length,
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            switch (index) {
              case 0:
                context.go('/details?method=go');
                break;
              case 1:
                context.push('/details?method=push');
                break;
              case 2:
                context.replace('/details?method=replace');
                break;
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[100 * ((index % 8) + 1)],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                methods[index],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
