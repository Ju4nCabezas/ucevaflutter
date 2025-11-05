class UniversidadFb {
  final String nit;
  final String nombre;
  final String direccion;
  final String pagina_web;
  final String telefono;

  UniversidadFb({
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.pagina_web,
    required this.telefono,
  });

  factory UniversidadFb.fromMap(String nit, Map<String, dynamic> data) {
    return UniversidadFb(
      nit: nit,
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      pagina_web: data['pagina_web'] ?? '',
      telefono: data['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'direccion': direccion,
      'pagina_web': pagina_web,
      'telefono': telefono,
    };
  }
}
