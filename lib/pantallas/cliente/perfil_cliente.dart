// lib/pantallas/cliente/perfil_cliente.dart
import 'package:flutter/material.dart';
import '../../servicios/servicio_global.dart';

class PerfilCliente extends StatelessWidget {
  const PerfilCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final correo = ServicioGlobal.getCorreo();
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, size: 48),
              title: Text(correo,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Rol: Cliente'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Solicitar servicio'),
              onPressed: () =>
                  Navigator.pushNamed(context, '/solicitar-servicio'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('Historial de solicitudes'),
              onPressed: () =>
                  Navigator.pushNamed(context, '/historial-servicios'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.report_problem),
              label: const Text('Reportar un problema'),
              onPressed: () =>
                  Navigator.pushNamed(context, '/reportar-problema'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ServicioGlobal.setUsuario(null);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (r) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cerrar sesión'),
            )
          ],
        ),
      ),
    );
  }
}
