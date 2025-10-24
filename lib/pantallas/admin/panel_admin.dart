import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class PanelAdmin extends StatefulWidget {
  @override
  State<PanelAdmin> createState() => _PanelAdminState();
}

class _PanelAdminState extends State<PanelAdmin> {
  int totalUsuarios = 0;
  int totalServicios = 0;
  int serviciosPendientes = 0;
  int serviciosCompletados = 0;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final usuarios = await BaseDatos.obtenerTodosUsuarios();
    final servicios = await BaseDatos.obtenerServicios();

    setState(() {
      totalUsuarios = usuarios.length;
      totalServicios = servicios.length;
      serviciosPendientes = servicios
          .where((s) => s['estado'] == 'pendiente' || s['estado'] == 'asignado')
          .length;
      serviciosCompletados =
          servicios.where((s) => s['estado'] == 'completado').length;
    });
  }

  void navegar(String ruta) {
    Navigator.pushNamed(context, ruta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel de Administración")),
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
                      color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text('Administrador',
                      style: TextStyle(color: Colors.white, fontSize: 20))
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestión de Usuarios'),
              onTap: () => navegar('/gestion-usuarios'),
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Gestión de Servicios'),
              onTap: () => navegar('/gestion-servicios'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: cargarDatos,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Resumen General',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                _buildCard(
                  'Usuarios Registrados',
                  totalUsuarios.toString(),
                  Icons.people,
                  Colors.blue,
                ),
                _buildCard(
                  'Servicios Totales',
                  totalServicios.toString(),
                  Icons.build,
                  Colors.orange,
                ),
                _buildCard(
                  'Pendientes / Asignados',
                  serviciosPendientes.toString(),
                  Icons.pending_actions,
                  Colors.amber,
                ),
                _buildCard(
                  'Completados',
                  serviciosCompletados.toString(),
                  Icons.done_all,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String titulo, String valor, IconData icono, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: color, size: 35),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              valor,
              style: TextStyle(fontSize: 28, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
