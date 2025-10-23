// lib/pantallas/cliente/historial_servicios.dart
import 'package:flutter/material.dart';
import '../../servicios/servicio_servicio.dart';
import '../../servicios/autenticacion_servicio.dart';

class HistorialServiciosPantalla extends StatefulWidget {
  const HistorialServiciosPantalla({Key? key}) : super(key: key);

  @override
  State<HistorialServiciosPantalla> createState() =>
      _HistorialServiciosPantallaState();
}

class _HistorialServiciosPantallaState
    extends State<HistorialServiciosPantalla> {
  final ServicioServicio _servicioServicio = ServicioServicio();
  final AutenticacionServicio _auth = AutenticacionServicio();
  List<Map<String, dynamic>> _lista = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _cargando = true);
    final usuario = _auth.usuarioActual;
    final correo = usuario != null ? usuario['correo'] as String? : null;
    final lista = await _servicioServicio.listarServicios(cliente: correo);
    setState(() {
      _lista = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis solicitudes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _lista.isEmpty
              ? const Center(child: Text('No tienes solicitudes registradas'))
              : RefreshIndicator(
                  onRefresh: _cargar,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _lista.length,
                    itemBuilder: (context, index) {
                      final s = _lista[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(s['nombre'] ?? ''),
                          subtitle: Text(s['descripcion'] ?? ''),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  (s['estado'] ?? '').toString().toUpperCase()),
                              const SizedBox(height: 6),
                              Text('Técnico: ${s['tecnico'] ?? '—'}',
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
