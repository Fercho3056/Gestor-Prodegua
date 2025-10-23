class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String rol; // cliente, tecnico, administrador

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
  });
}
