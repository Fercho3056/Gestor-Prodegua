// lib/pantallas/tecnico/perfil_tecnico.dart
import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';
import '../../servicios/servicio_global.dart';

class PerfilTecnico extends StatefulWidget {
  const PerfilTecnico({super.key});

  @override
  State<PerfilTecnico> createState() => _PerfilTecnicoState();
}

class _PerfilTecnicoState extends State<PerfilTecnico> {
  List<Map<String, dynamic>> _servicios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final correo = ServicioGlobal.getCorreo();
    _servicios = await BaseDatos.obtenerServicios(tecnico: correo);
    setState(() => _cargando = false);
  }

  Future<void> _cambiarEstado(int id, String estado) async {
    await BaseDatos.actualizarEstadoServicio(id, estado);
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil Técnico')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
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
