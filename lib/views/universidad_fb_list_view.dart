import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/universidad_fb.dart';
import '../services/universidad_service.dart';

class UniversidadFbListView extends StatelessWidget {
  const UniversidadFbListView({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building UniversidadFbListView');

    return Scaffold(
      appBar: AppBar(title: const Text('Universidades Firebase')),
      body: StreamBuilder<List<UniversidadFb>>(
        stream: UniversidadService.watchUniversidades(),
        builder: (context, snapshot) {
          print('StreamBuilder state: ${snapshot.connectionState}');
          print('StreamBuilder error: ${snapshot.error}');
          print('StreamBuilder data: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final universidades = snapshot.data ?? [];

          if (universidades.isEmpty) {
            return const Center(
              child: Text('No hay universidades registradas'),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              // Determinar el diseño según el ancho
              // Móvil: Lista vertical
              // Tablet/Desktop: Grid con múltiples columnas
              final bool useGrid = screenWidth > 600;
              final int crossAxisCount = screenWidth > 1200
                  ? 3 // Desktop grande: 3 columnas
                  : screenWidth > 800
                  ? 2 // Tablet/Desktop mediano: 2 columnas
                  : 1; // Móvil: 1 columna

              // Padding adaptativo
              final double padding = screenWidth > 600 ? 24 : 16;
              final double spacing = screenWidth > 600 ? 16 : 12;

              // Ancho máximo para contenido (centrado en pantallas muy grandes)
              final double maxWidth = screenWidth > 1400
                  ? 1400
                  : double.infinity;

              Widget listContent;

              if (useGrid && crossAxisCount > 1) {
                // Vista en Grid para pantallas grandes
                listContent = GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(padding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: screenWidth > 1200 ? 1.8 : 1.5,
                  ),
                  itemCount: universidades.length,
                  itemBuilder: (context, index) {
                    final uni = universidades[index];
                    return _UniversidadCard(
                      universidad: uni,
                      index: index,
                      isGridView: true,
                    );
                  },
                );
              } else {
                // Vista en Lista para móviles
                listContent = ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(padding),
                  itemCount: universidades.length,
                  itemBuilder: (context, index) {
                    final uni = universidades[index];
                    return _UniversidadCard(
                      universidad: uni,
                      index: index,
                      isGridView: false,
                    );
                  },
                );
              }

              // Centrar contenido en pantallas muy grandes
              if (maxWidth < double.infinity) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: listContent,
                  ),
                );
              }

              return listContent;
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/universidadfb/create'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}

class _UniversidadCard extends StatelessWidget {
  final UniversidadFb universidad;
  final int index;
  final bool isGridView;

  const _UniversidadCard({
    required this.universidad,
    required this.index,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: isGridView ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/universidadfb/edit/${universidad.nit}'),
        child: Padding(
          padding: EdgeInsets.all(isGridView ? 12 : 16),
          child: isGridView
              ? _buildGridContent(context, colorScheme)
              : _buildListContent(context, colorScheme),
        ),
      ),
    );
  }

  // Contenido para vista de lista (móvil)
  Widget _buildListContent(BuildContext context, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                universidad.nombre,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on_outlined, universidad.direccion),
              _buildInfoRow(Icons.business_outlined, universidad.nit),
              _buildInfoRow(Icons.phone_outlined, universidad.telefono),
              _buildInfoRow(Icons.language_outlined, universidad.pagina_web),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: colorScheme.error.withValues(alpha: 0.8),
            size: 20,
          ),
          tooltip: 'Eliminar',
          visualDensity: VisualDensity.compact,
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  // Contenido para vista de grid (tablet/desktop)
  Widget _buildGridContent(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                universidad.nombre,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error.withValues(alpha: 0.8),
                size: 18,
              ),
              tooltip: 'Eliminar',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.location_on_outlined, universidad.direccion),
              _buildInfoRow(Icons.business_outlined, universidad.nit),
              _buildInfoRow(Icons.phone_outlined, universidad.telefono),
              _buildInfoRow(Icons.language_outlined, universidad.pagina_web),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text.isEmpty ? 'No especificado' : text,
                style: TextStyle(
                  fontSize: 13,
                  color: text.isEmpty
                      ? Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.5)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: text.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Estás seguro de eliminar esta categoría?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    universidad.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (universidad.direccion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      universidad.direccion,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(fontSize: 12, color: colorScheme.error),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      try {
        await UniversidadService.deleteUniversidad(universidad.nit);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Universidad "${universidad.nombre}" eliminada'),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
