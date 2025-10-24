import 'package:proyecto_prodegua/servicios/base_datos.dart';

class AutenticacionServicio {
  // 🔐 Registrar usuario
  Future<Map<String, dynamic>?> registrar(String correo, String contrasena,
      {String rol = "cliente"}) async {
    try {
      // Verificar si ya existe
      final existente = await BaseDatos.obtenerUsuarioPorCorreo(correo);
      if (existente != null) {
        print("⚠️ Usuario ya existe: $correo");
        return null;
      }

      // Insertar usuario en la base de datos
      final id = await BaseDatos.insertarUsuario(correo, contrasena, rol);

      // Retornar el usuario completo con el ID asignado
      final user = {
        'id': id,
        'correo': correo,
        'contrasena': contrasena,
        'rol': rol,
      };

      print("✅ Usuario registrado: $user");
      return user;
    } catch (e) {
      print("❌ Error al registrar usuario: $e");
      return null;
    }
  }

  // 🔑 Iniciar sesión
  Future<Map<String, dynamic>?> iniciarSesion(
      String correo, String contrasena) async {
    try {
      final user =
          await BaseDatos.obtenerUsuarioPorCredenciales(correo, contrasena);
      if (user != null) {
        print("✅ Sesión iniciada: ${user['correo']} (${user['rol']})");
      } else {
        print("❌ Credenciales inválidas para $correo");
      }
      return user;
    } catch (e) {
      print("❌ Error en inicio de sesión: $e");
      return null;
    }
  }

  // 👥 Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    try {
      return await BaseDatos.obtenerTodosUsuarios();
    } catch (e) {
      print("❌ Error al obtener usuarios: $e");
      return [];
    }
  }

  // 🗑️ Eliminar usuario
  Future<bool> eliminarUsuario(int id) async {
    try {
      final res = await BaseDatos.eliminarUsuario(id);
      return res > 0;
    } catch (e) {
      print("❌ Error al eliminar usuario: $e");
      return false;
    }
  }
}
