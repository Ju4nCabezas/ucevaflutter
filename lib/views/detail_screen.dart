import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;
  final String description;

  const DetailScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle #$id')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(imageUrl, height: 240, fit: BoxFit.cover)
            else
              const SizedBox.shrink(),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/'),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
