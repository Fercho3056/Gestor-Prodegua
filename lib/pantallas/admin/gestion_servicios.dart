// lib/pantallas/admin/gestion_servicios.dart
import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class GestionServicios extends StatefulWidget {
  const GestionServicios({super.key});

  @override
  State<GestionServicios> createState() => _GestionServiciosState();
}

class _GestionServiciosState extends State<GestionServicios> {
  List<Map<String, dynamic>> _servicios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    _servicios = await BaseDatos.obtenerServicios();
    setState(() => _cargando = false);
  }

  Future<void> _cambiarEstado(int id, String estado) async {
    await BaseDatos.actualizarEstadoServicio(id, estado);
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de servicios')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _servicios.length,
              itemBuilder: (context, i) {
                final s = _servicios[i];
                return Card(
                  child: ListTile(
                    title: Text(s['nombre'] ?? ''),
                    subtitle: Text(
                        'Cliente: ${s['cliente'] ?? ''}\nEstado: ${s['estado'] ?? ''}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) => _cambiarEstado(s['id'] as int, v),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'pendiente', child: Text('Pendiente')),
                        const PopupMenuItem(
                            value: 'en proceso', child: Text('En proceso')),
                        const PopupMenuItem(
                            value: 'completado', child: Text('Completado')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
