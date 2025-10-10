import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/apiService.dart';
import 'package:go_router/go_router.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late ApiService apiService;
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'https://www.themealdb.com/api/json/v1/1');
    _futureCategories = apiService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listado')),
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay elementos'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final c = categories[i];
                return ListTile(
                  leading: Image.network(
                    c.thumbnail,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(c.name),
                  subtitle: Text(
                    c.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    context.goNamed(
                      'detail',
                      pathParameters: {'id': c.id},
                      queryParameters: {
                        'title': c.name,
                        'url': c.thumbnail,
                        'description': c.description,
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
