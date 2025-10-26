import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class PerfilCliente extends StatefulWidget {
  const PerfilCliente({super.key});

  @override
  State<PerfilCliente> createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  List<Map<String, dynamic>> _servicios = [];
  int totalServicios = 0;
  int completados = 0;
  int pendientes = 0;

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  Future<void> _cargarServicios() async {
    const correoCliente =
        'cliente@prodegua.com'; // 🔧 Cambia esto por el usuario logueado
    final servicios = await BaseDatos.obtenerServicios(cliente: correoCliente);

    setState(() {
      _servicios = servicios;
      totalServicios = servicios.length;
      completados = servicios.where((s) => s['estado'] == 'completado').length;
      pendientes = servicios.where((s) => s['estado'] == 'pendiente').length;
    });
  }

  void _navegar(String ruta) {
    Navigator.pushNamed(context, ruta);
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

  Future<void> _confirmarEliminar(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Servicio"),
        content: const Text("¿Estás seguro de eliminar este servicio?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Eliminar")),
        ],
      ),
    );

    if (confirm == true) {
      await BaseDatos.eliminarServicio(id);
      _cargarServicios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel del Cliente')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Cliente Prodegua',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'cliente@prodegua.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Solicitar nuevo servicio'),
              onTap: () => _navegar('/solicitar-servicio'),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial de servicios'),
              onTap: _cargarServicios,
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
        onRefresh: _cargarServicios,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "💼 Panel del Cliente",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Dashboard de estadísticas
              Row(
                children: [
                  _crearCard("Total", "$totalServicios", Icons.assignment,
                      Colors.blue),
                  _crearCard("Pendientes", "$pendientes", Icons.pending,
                      Colors.orange),
                  _crearCard("Completados", "$completados", Icons.check_circle,
                      Colors.green),
                ],
              ),

              const SizedBox(height: 25),
              const Divider(),
              const Text(
                "🧾 Historial de Servicios",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              if (_servicios.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No tienes servicios registrados."),
                )
              else
                Column(
                  children: _servicios.map((servicio) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(servicio['nombre']),
                        subtitle: Text(
                          "Estado: ${servicio['estado']}\nFecha: ${servicio['fecha_creacion']}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarEliminar(servicio['id']),
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
