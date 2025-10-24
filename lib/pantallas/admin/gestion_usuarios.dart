// lib/pantallas/admin/gestion_usuarios.dart
import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class GestionUsuarios extends StatefulWidget {
  const GestionUsuarios({super.key});

  @override
  State<GestionUsuarios> createState() => _GestionUsuariosState();
}

class _GestionUsuariosState extends State<GestionUsuarios> {
  List<Map<String, dynamic>> _usuarios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    _usuarios = await BaseDatos.obtenerTodosUsuarios();
    setState(() => _cargando = false);
  }

  Future<void> _eliminar(int id) async {
    await BaseDatos.eliminarUsuario(id);
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de usuarios')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, i) {
                final u = _usuarios[i];
                return ListTile(
                  title: Text(u['correo']),
                  subtitle: Text('Rol: ${u['rol']}'),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminar(u['id'] as int)),
                );
              },
            ),
    );
  }
}
