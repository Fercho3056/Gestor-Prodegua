import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class UsuariosAdminPantalla extends StatefulWidget {
  const UsuariosAdminPantalla({Key? key}) : super(key: key);

  @override
  State<UsuariosAdminPantalla> createState() => _UsuariosAdminPantallaState();
}

class _UsuariosAdminPantallaState extends State<UsuariosAdminPantalla> {
  List<Map<String, dynamic>> _usuarios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    setState(() => _cargando = true);
    try {
      final lista = await BaseDatos.obtenerTodosUsuarios();
      setState(() {
        _usuarios = lista;
      });
    } catch (e) {
      debugPrint("❌ Error al obtener usuarios: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _eliminarUsuario(int id) async {
    await BaseDatos.eliminarUsuario(id);
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Usuarios Registrados"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.admin_panel_settings,
                      size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Administrador Prodegua',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.blueAccent),
              title: const Text("Panel principal"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/panel-admin');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar sesión"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _usuarios.isEmpty
              ? const Center(
                  child: Text(
                    "No hay usuarios registrados",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: _usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = _usuarios[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.person,
                              color: Colors.blueAccent),
                          title: Text(usuario['correo'] ?? 'Sin correo'),
                          subtitle:
                              Text('Rol: ${usuario['rol'] ?? 'Desconocido'}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarEliminacion(usuario),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _confirmarEliminacion(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar usuario"),
        content: Text(
            "¿Seguro que deseas eliminar al usuario ${usuario['correo']}?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Eliminar"),
            onPressed: () {
              Navigator.pop(context);
              _eliminarUsuario(usuario['id']);
            },
          ),
        ],
      ),
    );
  }
}
