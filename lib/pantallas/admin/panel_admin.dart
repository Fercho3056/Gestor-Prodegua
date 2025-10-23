import 'package:flutter/material.dart';

class PanelAdmin extends StatelessWidget {
  const PanelAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Panel del Administrador",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      // 🧭 Menú lateral (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
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
              leading: const Icon(Icons.people, color: Colors.blueAccent),
              title: const Text("Usuarios Registrados"),
              onTap: () {
                Navigator.pushNamed(context, '/usuarios-admin');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.green),
              title: const Text("Gestión de Usuarios"),
              onTap: () {
                Navigator.pushNamed(context, '/gestion-usuarios');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build, color: Colors.orange),
              title: const Text("Gestión de Servicios"),
              onTap: () {
                Navigator.pushNamed(context, '/gestion-servicios');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar Sesión"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      // 💠 Contenido principal
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings,
                size: 90, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              "Bienvenido al Panel Administrativo de Prodegua",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // 🔹 Botón: Usuarios Registrados
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/usuarios-admin'),
              icon: const Icon(Icons.people, color: Colors.white),
              label: const Text(
                "Ver usuarios registrados",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                shadowColor: Colors.black26,
                elevation: 5,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Botón: Gestión de Servicios
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/gestion-servicios'),
              icon: const Icon(Icons.settings, color: Colors.white),
              label: const Text(
                "Ver servicios",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                shadowColor: Colors.black26,
                elevation: 5,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Botón: Gestión de Usuarios
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/gestion-usuarios'),
              icon: const Icon(Icons.supervisor_account, color: Colors.white),
              label: const Text(
                "Administrar usuarios",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                shadowColor: Colors.black26,
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
