// lib/pantallas/cliente/ver_estado_servicios.dart
import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';
import '../../servicios/servicio_global.dart';

class VerEstadoServicios extends StatefulWidget {
  const VerEstadoServicios({super.key});

  @override
  State<VerEstadoServicios> createState() => _VerEstadoServiciosState();
}

class _VerEstadoServiciosState extends State<VerEstadoServicios> {
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
    _servicios = await BaseDatos.obtenerServicios(cliente: correo);
    setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _servicios.isEmpty
              ? const Center(child: Text('No hay solicitudes'))
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _servicios.length,
                    itemBuilder: (context, i) {
                      final s = _servicios[i];
                      return Card(
                        child: ListTile(
                          title: Text(s['nombre'] ?? ''),
                          subtitle: Text(s['descripcion'] ?? ''),
                          trailing: Text(
                              (s['estado'] ?? '').toString().toUpperCase()),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
