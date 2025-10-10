import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/categories.php');
    final resp = await http.get(uri);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final List list = data['categories'];
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar categorías: ${resp.statusCode}');
    }
  }
}
