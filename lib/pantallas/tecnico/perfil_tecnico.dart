import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class PerfilTecnico extends StatefulWidget {
  const PerfilTecnico({super.key});

  @override
  State<PerfilTecnico> createState() => _PerfilTecnicoState();
}

class _PerfilTecnicoState extends State<PerfilTecnico> {
  int totalServicios = 0;
  int completados = 0;
  int pendientes = 0;
  List<Map<String, dynamic>> serviciosAsignados = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    // 🔧 Cambia este correo por el del técnico logueado si tienes sesión activa
    const correoTecnico = 'tecnico@prodegua.com';
    final servicios = await BaseDatos.obtenerServicios(tecnico: correoTecnico);

    setState(() {
      serviciosAsignados = servicios;
      totalServicios = servicios.length;
      completados = servicios.where((s) => s['estado'] == 'completado').length;
      pendientes = servicios.where((s) => s['estado'] == 'pendiente').length;
    });
  }

  Future<void> _actualizarEstado(int id, String nuevoEstado) async {
    await BaseDatos.actualizarEstadoServicio(id, nuevoEstado);
    _cargarDatos();
  }

  Widget _crearCard(String titulo, String valor, IconData icono, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icono, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                titulo,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                valor,
                style: TextStyle(
                    fontSize: 22, color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navegar(String ruta) {
    Navigator.pushNamed(context, ruta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel del Técnico')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orangeAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.engineering, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Técnico Asignado',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'tecnico@prodegua.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Servicios Asignados'),
              onTap: _cargarDatos,
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Perfil'),
              onTap: () => _navegar('/editar-perfil'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "🔧 Panel del Técnico",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Estadísticas
              Row(
                children: [
                  _crearCard("Servicios Totales", "$totalServicios",
                      Icons.build, Colors.teal),
                  _crearCard(
                      "Pendientes", "$pendientes", Icons.pending, Colors.red),
                  _crearCard("Completados", "$completados", Icons.check_circle,
                      Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                "🧰 Servicios Asignados",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Lista de servicios
              if (serviciosAsignados.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No tienes servicios asignados actualmente."),
                )
              else
                Column(
                  children: serviciosAsignados.map((servicio) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(servicio['nombre']),
                        subtitle: Text(
                          "Cliente: ${servicio['cliente']}\nEstado: ${servicio['estado']}",
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (valor) {
                            _actualizarEstado(servicio['id'], valor);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'pendiente',
                              child: Text('Marcar Pendiente'),
                            ),
                            const PopupMenuItem(
                              value: 'completado',
                              child: Text('Marcar Completado'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
