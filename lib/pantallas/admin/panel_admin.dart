import 'package:flutter/material.dart';
import '../compartido/perfil_usuario.dart';
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
  String correo = 'admin@prodegua.com';

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
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

  void _abrirPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PerfilUsuario(correo: correo, rol: "admin"),
      ),
    );
  }

  void _navegar(String ruta) => Navigator.pushNamed(context, ruta);

  Widget _card(String t, String v, IconData i, Color c) => Expanded(
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              Icon(i, size: 40, color: c),
              const SizedBox(height: 8),
              Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(v,
                  style: TextStyle(
                      fontSize: 20, color: c, fontWeight: FontWeight.bold))
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Administrador'),
        actions: [
          IconButton(
              onPressed: _abrirPerfil,
              icon: const Icon(Icons.account_circle_outlined))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.admin_panel_settings,
                      size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Administrador",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("admin@prodegua.com",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Gestión de Usuarios"),
              onTap: () => _navegar('/gestion-usuarios'),
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text("Gestión de Servicios"),
              onTap: () => _navegar('/gestion-servicios'),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text("Añadir Técnico/Admin"),
              onTap: () => _navegar('/usuarios-admin'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar Sesión"),
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
          child: Column(children: [
            const Text("📈 Estadísticas Generales",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(children: [
              _card("Usuarios", "$totalUsuarios", Icons.people, Colors.blue),
              _card("Técnicos", "$totalTecnicos", Icons.engineering,
                  Colors.orange),
              _card("Servicios", "$totalServicios", Icons.home_repair_service,
                  Colors.teal),
            ]),
            const SizedBox(height: 20),
            Row(children: [
              _card("Pendientes", "$pendientes", Icons.pending, Colors.red),
              _card("Completados", "$completados", Icons.check_circle,
                  Colors.green),
            ]),
            const SizedBox(height: 30),
            const Divider(),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text("Añadir Usuario"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.all(18)),
              onPressed: () => _navegar('/usuarios-admin'),
            ),
          ]),
        ),
      ),
    );
  }
}
