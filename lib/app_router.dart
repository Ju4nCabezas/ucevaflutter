import 'package:go_router/go_router.dart';
import '../views/list_screen.dart';
import '../views/detail_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(name: 'list', path: '/', builder: (context, state) => ListScreen()),
    GoRoute(
      name: 'detail',
      path: '/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final title = state.uri.queryParameters['title'] ?? '';
        final url = state.uri.queryParameters['url'] ?? '';
        final description = state.uri.queryParameters['description'] ?? '';
        return DetailScreen(
          id: id,
          title: title,
          imageUrl: url,
          description: description,
        );
      },
    ),
  ],
);
