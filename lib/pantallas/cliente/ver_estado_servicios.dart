import 'package:flutter/material.dart';

class VerEstadoServicios extends StatelessWidget {
  final List<Map<String, String>> servicios = [
    {"tipo": "Eléctrico", "estado": "En proceso"},
    {"tipo": "Hidráulico", "estado": "Completado"},
    {"tipo": "Mecánico", "estado": "Pendiente"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Servicios")),
      body: ListView.builder(
        itemCount: servicios.length,
        itemBuilder: (context, index) {
          final servicio = servicios[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Servicio: ${servicio['tipo']}"),
              subtitle: Text("Estado: ${servicio['estado']}"),
              leading: Icon(Icons.build_circle),
            ),
          );
        },
      ),
    );
  }
}
