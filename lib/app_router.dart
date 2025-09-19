import 'package:go_router/go_router.dart';
import 'package:ucevaflutter/views/details/details.dart';
import 'package:ucevaflutter/views/home/HomePage.dart';
import 'views/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), // Usa HomeView
    ),

    GoRoute(
      path: '/details',
      builder: (context, state) {
        final method = state.uri.queryParameters['method'] ?? 'sin método';
        return DetailsScreen(method: method);
      },
    ),
  ],
);
