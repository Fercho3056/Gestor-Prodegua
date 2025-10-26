import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyecto_prodegua/servicios/base_datos.dart';
import 'package:proyecto_prodegua/pantallas/compartido/editar_perfil.dart';

class PerfilUsuario extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const PerfilUsuario({super.key, required this.usuario});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  int serviciosTotales = 0;
  int serviciosCompletados = 0;
  int serviciosPendientes = 0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final rol = widget.usuario['rol'];
    final correo = widget.usuario['correo'];

    final servicios = await BaseDatos.obtenerServicios(
      cliente: rol == 'cliente' ? correo : null,
      tecnico: rol == 'tecnico' ? correo : null,
    );

    setState(() {
      serviciosTotales = servicios.length;
      serviciosCompletados =
          servicios.where((s) => s['estado'] == 'completado').length;
      serviciosPendientes =
          servicios.where((s) => s['estado'] == 'pendiente').length;
    });
  }

  Widget _crearEstadistica(String titulo, int valor, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            "$valor",
            style: TextStyle(
                color: color, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(titulo, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario;
    final rol = usuario['rol'] ?? 'Desconocido';
    final correo = usuario['correo'] ?? 'No especificado';
    final foto = usuario['foto'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil de Usuario"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarPerfil(usuario: usuario),
                ),
              );
              setState(() => _cargarDatos());
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🧑 Foto de perfil
              CircleAvatar(
                radius: 60,
                backgroundImage: foto != null && foto != ''
                    ? FileImage(File(foto))
                    : const AssetImage('assets/avatar.png') as ImageProvider,
              ),

              const SizedBox(height: 15),
              Text(
                correo,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                rol.toUpperCase(),
                style: const TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),

              // 📊 Estadísticas tipo GitHub
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      _crearEstadistica('Servicios Totales', serviciosTotales,
                          Colors.blueAccent),
                      _crearEstadistica(
                          'Completados', serviciosCompletados, Colors.green),
                      _crearEstadistica(
                          'Pendientes', serviciosPendientes, Colors.redAccent),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ⚙️ Acciones según rol
              if (rol == 'cliente') ...[
                _crearBoton(
                    icon: Icons.add_circle,
                    color: Colors.blue,
                    texto: 'Solicitar nuevo servicio',
                    ruta: '/solicitar-servicio'),
                _crearBoton(
                    icon: Icons.receipt_long,
                    color: Colors.orange,
                    texto: 'Ver estado de mis servicios',
                    ruta: '/ver-estado'),
              ] else if (rol == 'tecnico') ...[
                _crearBoton(
                    icon: Icons.engineering,
                    color: Colors.teal,
                    texto: 'Ver servicios asignados',
                    ruta: '/perfil-tecnico'),
              ] else if (rol == 'admin') ...[
                _crearBoton(
                    icon: Icons.dashboard,
                    color: Colors.indigo,
                    texto: 'Ir al panel administrativo',
                    ruta: '/panel-admin'),
              ],

              const SizedBox(height: 40),
              TextButton.icon(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                icon: const Icon(Icons.logout),
                label: const Text("Cerrar sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearBoton({
    required IconData icon,
    required String texto,
    required String ruta,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, ruta),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          texto,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 55),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
