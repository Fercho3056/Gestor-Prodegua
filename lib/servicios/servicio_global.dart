// lib/servicios/servicio_global.dart
class ServicioGlobal {
  static Map<String, dynamic>? usuarioActual;

  static void setUsuario(Map<String, dynamic>? usuario) {
    usuarioActual = usuario;
  }

  static Map<String, dynamic>? getUsuario() => usuarioActual;

  static String getCorreo() => usuarioActual?['correo']?.toString() ?? '';
  static String getRol() => usuarioActual?['rol']?.toString() ?? 'cliente';
  static int? getId() => usuarioActual?['id'] as int?;
}
