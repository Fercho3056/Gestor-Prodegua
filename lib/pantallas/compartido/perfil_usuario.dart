import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../servicios/base_datos.dart';
import '../compartido/editar_perfil.dart';

class PerfilUsuario extends StatefulWidget {
  final String correo;
  final String rol;

  const PerfilUsuario({super.key, required this.correo, required this.rol});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  File? _imagenPerfil;
  Map<String, dynamic>? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _cargarImagen();
  }

  Future<void> _cargarUsuario() async {
    final user = await BaseDatos.obtenerUsuarioPorCorreo(widget.correo);
    if (user != null) {
      setState(() => _usuario = user);
    }
  }

  Future<void> _cargarImagen() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${widget.correo}_perfil.jpg';
    final file = File(path);
    if (await file.exists()) {
      setState(() => _imagenPerfil = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final correo = widget.correo;
    final rol = widget.rol;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar perfil',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarPerfil(correo: correo),
                ),
              );
              await _cargarUsuario();
              await _cargarImagen();
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            tooltip: 'Ver estadísticas',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/estadisticas',
                arguments: {'correo': correo, 'rol': rol},
              );
            },
          ),
        ],
      ),
      body: _usuario == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    backgroundImage: _imagenPerfil != null
                        ? FileImage(_imagenPerfil!)
                        : const AssetImage('assets/images/default_user.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _usuario?['correo'] ?? correo,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Rol: ${_usuario?['rol'] ?? rol}',
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 10),

                  // Sección de estadísticas rápidas
                  const Text(
                    "📊 Actividad reciente",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  FutureBuilder(
                    future: BaseDatos.obtenerServicios(
                      cliente: rol == 'cliente' ? correo : null,
                      tecnico: rol == 'tecnico' ? correo : null,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final lista = snapshot.data as List<Map<String, dynamic>>;
                      final total = lista.length;
                      final completados = lista
                          .where((s) => s['estado'] == 'completado')
                          .length;
                      final pendientes =
                          lista.where((s) => s['estado'] == 'pendiente').length;

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _filaEstadistica('Total servicios', total),
                              const Divider(),
                              _filaEstadistica('Pendientes', pendientes),
                              _filaEstadistica('Completados', completados),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _filaEstadistica(String titulo, int valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16)),
          Text(
            valor.toString(),
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
