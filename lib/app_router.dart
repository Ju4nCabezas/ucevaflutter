import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ucevaflutter/views/universidad_fb_form_view.dart';
import 'package:ucevaflutter/views/universidad_fb_list_view.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'universidades.list',
      builder: (context, state) => const UniversidadFbListView(),
    ),
    GoRoute(
      path: '/universidadfb/create',
      name: 'universidadfb.create',
      builder: (context, state) => const UniversidadFbFormView(),
    ),
    GoRoute(
      path: '/categoriasfb/edit/:id',
      name: 'categorias.edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return UniversidadFbFormView(id: id);
      },
    ),
  ],
);
