import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class PanelAdmin extends StatefulWidget {
  const PanelAdmin({super.key});

  @override
  State<PanelAdmin> createState() => _PanelAdminState();
}

class _PanelAdminState extends State<PanelAdmin> {
  int totalUsuarios = 0;
  int totalTecnicos = 0;
  int totalServicios = 0;
  int pendientes = 0;
  int completados = 0;

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
  }

  Future<void> _cargarEstadisticas() async {
    final usuarios = await BaseDatos.obtenerTodosUsuarios();
    final servicios = await BaseDatos.obtenerServicios();

    setState(() {
      totalUsuarios = usuarios.length;
      totalTecnicos = usuarios.where((u) => u['rol'] == 'tecnico').length;
      totalServicios = servicios.length;
      pendientes = servicios.where((s) => s['estado'] == 'pendiente').length;
      completados = servicios.where((s) => s['estado'] == 'completado').length;
    });
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
      appBar: AppBar(title: const Text('Panel de Administración')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.admin_panel_settings,
                      size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Administrador',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'admin@prodegua.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestión de Usuarios'),
              onTap: () => _navegar('/gestion-usuarios'),
            ),
            ListTile(
              leading: const Icon(Icons.home_repair_service),
              title: const Text('Gestión de Servicios'),
              onTap: () => _navegar('/gestion-servicios'),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Añadir / Ver Usuarios'),
              onTap: () => _navegar('/gestion-usuarios'),
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
        onRefresh: _cargarEstadisticas,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "📊 Estadísticas Generales",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Filas de tarjetas
              Row(
                children: [
                  _crearCard(
                      "Usuarios", "$totalUsuarios", Icons.people, Colors.blue),
                  _crearCard("Técnicos", "$totalTecnicos", Icons.engineering,
                      Colors.orange),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _crearCard(
                      "Servicios", "$totalServicios", Icons.build, Colors.teal),
                  _crearCard("Pendientes", "$pendientes", Icons.pending_actions,
                      Colors.red),
                  _crearCard("Completados", "$completados", Icons.check_circle,
                      Colors.green),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                "⚙️ Acciones Rápidas",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.people),
                    label: const Text("Ver / Crear Usuarios"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                    ),
                    onPressed: () => _navegar('/gestion-usuarios'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.build),
                    label: const Text("Ver Servicios"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                    ),
                    onPressed: () => _navegar('/gestion-servicios'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Editar Perfil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                    ),
                    onPressed: () => _navegar('/editar-perfil'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
