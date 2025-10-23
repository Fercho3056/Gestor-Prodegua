import 'package:flutter/material.dart';
import 'package:proyecto_prodegua/servicios/base_datos.dart';

class HistorialServicios extends StatefulWidget {
  final String correoCliente;
  const HistorialServicios({Key? key, required this.correoCliente})
      : super(key: key);

  @override
  State<HistorialServicios> createState() => _HistorialServiciosState();
}

class _HistorialServiciosState extends State<HistorialServicios> {
  List<Map<String, dynamic>> _servicios = [];

  Future<void> _cargarServicios() async {
    final datos =
        await BaseDatos.obtenerServicios(cliente: widget.correoCliente);
    setState(() {
      _servicios = datos;
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial de servicios")),
      body: _servicios.isEmpty
          ? const Center(child: Text("No hay servicios registrados"))
          : ListView.builder(
              itemCount: _servicios.length,
              itemBuilder: (context, i) {
                final s = _servicios[i];
                return Card(
                  child: ListTile(
                    title: Text(s['nombre']),
                    subtitle: Text(s['descripcion']),
                    trailing: Text(
                      s['estado'],
                      style: TextStyle(
                        color: s['estado'] == 'pendiente'
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
