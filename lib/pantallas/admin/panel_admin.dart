import 'package:flutter/material.dart';
import '../compartido/perfil_usuario.dart';
import '../../servicios/base_datos.dart';

class PanelAdmin extends StatefulWidget {
  const PanelAdmin({super.key});

  @override
  State<PanelAdmin> createState() => _PanelAdminState();
}

class _PanelAdminState extends State<PanelAdmin>
    with SingleTickerProviderStateMixin {
  int totalUsuarios = 0;
  int totalTecnicos = 0;
  int totalServicios = 0;
  int pendientes = 0;
  int completados = 0;
  String correo = 'admin@prodegua.com';
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _cargarDatos();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
    _animController.forward(from: 0);
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

  Widget _card(
      String t, String v, IconData i, Color c, Animation<double> anim) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: c.withOpacity(0.3),
        child: Container(
          width: 110,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(i, size: 40, color: c),
              const SizedBox(height: 10),
              Text(t,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Text(v,
                  style: TextStyle(
                      fontSize: 20, color: c, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Administrador'),
        backgroundColor: Colors.indigo,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
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
              leading: const Icon(Icons.bar_chart),
              title: const Text("Ver Estadísticas"),
              onTap: () => _navegar('/estadisticas'),
            ),
            const Divider(),
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
          child: Column(
            children: [
              const Text(
                "📊 Dashboard General",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _card("Usuarios", "$totalUsuarios", Icons.people,
                      Colors.blueAccent, anim),
                  _card("Técnicos", "$totalTecnicos", Icons.engineering,
                      Colors.orange, anim),
                  _card("Servicios", "$totalServicios",
                      Icons.home_repair_service, Colors.teal, anim),
                  _card("Pendientes", "$pendientes", Icons.pending_actions,
                      Colors.redAccent, anim),
                  _card("Completados", "$completados", Icons.check_circle,
                      Colors.green, anim),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text("Añadir Usuario"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _navegar('/usuarios-admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
