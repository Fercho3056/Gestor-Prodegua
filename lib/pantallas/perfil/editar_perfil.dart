// lib/pantallas/perfil/editar_perfil.dart
import 'package:flutter/material.dart';
import '../../servicios/autenticacion_servicio.dart';
import '../../servicios/base_datos.dart';

class EditarPerfilPantalla extends StatefulWidget {
  const EditarPerfilPantalla({Key? key}) : super(key: key);

  @override
  State<EditarPerfilPantalla> createState() => _EditarPerfilPantallaState();
}

class _EditarPerfilPantallaState extends State<EditarPerfilPantalla> {
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final AutenticacionServicio _auth = AutenticacionServicio();
  Map<String, dynamic>? _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = _auth.usuarioActual;
    _correoController.text = _usuario?['correo'] ?? '';
  }

  Future<void> _guardar() async {
    final correoNuevo = _correoController.text.trim();
    final passNuevo = _contrasenaController.text.trim();

    if (correoNuevo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El correo no puede quedar vacío')));
      return;
    }

    // Simple: eliminamos el usuario viejo y creamos uno nuevo con mismo rol.
    try {
      final id = _usuario?['id'] as int?;
      final rol = _usuario?['rol'] as String?;
      if (id == null) throw 'Usuario no válido';

      // eliminar antiguo e insertar nuevo (sencillo)
      await BaseDatos.eliminarUsuario(id);
      await BaseDatos.insertarUsuario(
          correoNuevo,
          passNuevo.isEmpty ? (_usuario?['contrasena'] ?? '') : passNuevo,
          rol ?? 'cliente');

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
      // Cerrar sesión para que reingrese con nuevo correo
      await _auth.cerrarSesion();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                    controller: _correoController,
                    decoration: const InputDecoration(labelText: 'Correo')),
                const SizedBox(height: 12),
                TextField(
                    controller: _contrasenaController,
                    decoration: const InputDecoration(
                        labelText: 'Nueva contraseña (opcional)')),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _guardar,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: const Text('Guardar cambios')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
