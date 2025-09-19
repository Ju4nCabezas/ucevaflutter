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
    // Rutas para el paso de parámetros
    GoRoute(
      path: '/details',
      builder: (context, state) => const DetailsScreen(),
    ),
  ],
);
