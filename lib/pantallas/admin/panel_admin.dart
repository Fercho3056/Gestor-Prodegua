import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class PanelAdmin extends StatefulWidget {
  @override
  State<PanelAdmin> createState() => _PanelAdminState();
}

class _PanelAdminState extends State<PanelAdmin> {
  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> servicios = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final todosUsuarios = await BaseDatos.obtenerTodosUsuarios();
    final todosServicios = await BaseDatos.obtenerServicios();
    setState(() {
      usuarios = todosUsuarios;
      servicios = todosServicios;
      cargando = false;
    });
  }

  Future<void> _eliminarUsuario(int id) async {
    await BaseDatos.eliminarUsuario(id);
    await _cargarDatos();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Usuario eliminado")));
  }

  Future<void> _eliminarServicio(int id) async {
    await BaseDatos.eliminarServicio(id);
    await _cargarDatos();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Servicio eliminado")));
  }

  Future<void> _asignarTecnicoDialog(int servicioId) async {
    final usuarios = await BaseDatos.obtenerTodosUsuarios();
    final tecnicos = usuarios.where((u) {
      final rol = (u['rol'] ?? '').toString().toLowerCase();
      return rol == 'tecnico';
    }).toList();

    if (tecnicos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay técnicos disponibles')),
      );
      return;
    }

    String? seleccionado = tecnicos.first['correo']?.toString();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Asignar técnico'),
              content: DropdownButtonFormField<String>(
                value: seleccionado,
                items: tecnicos.map<DropdownMenuItem<String>>((t) {
                  final correo = t['correo']?.toString() ?? '';
                  return DropdownMenuItem<String>(
                    value: correo,
                    child: Text(correo),
                  );
                }).toList(),
                onChanged: (v) => setStateDialog(() => seleccionado = v),
                decoration:
                    const InputDecoration(labelText: 'Seleccione técnico'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (seleccionado == null || seleccionado!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Seleccione un técnico')),
                      );
                      return;
                    }
                    await BaseDatos.asignarTecnico(servicioId, seleccionado!);
                    Navigator.pop(context);
                    await _cargarDatos();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Técnico asignado')),
                    );
                  },
                  child: const Text('Asignar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Administrativo"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text("Menú Admin",
                  style: TextStyle(color: Colors.white, fontSize: 22)),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Usuarios"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text("Servicios"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar Sesión"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("👥 Usuarios registrados",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...usuarios.map((u) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(u['correo'] ?? 'Desconocido'),
                      subtitle: Text('Rol: ${u['rol']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarUsuario(u['id']),
                      ),
                    ),
                  )),
              const Divider(height: 32),
              const Text("🧰 Servicios registrados",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...servicios.map((s) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(s['nombre'] ?? 'Sin nombre'),
                      subtitle: Text(
                        "Cliente: ${s['cliente']} • Estado: ${s['estado']}\n"
                        "Técnico: ${s['tecnico'] ?? 'No asignado'}",
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'asignar') {
                            _asignarTecnicoDialog(s['id']);
                          } else if (value == 'eliminar') {
                            _eliminarServicio(s['id']);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'asignar',
                            child: Text("Asignar técnico"),
                          ),
                          const PopupMenuItem(
                            value: 'eliminar',
                            child: Text("Eliminar servicio"),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
