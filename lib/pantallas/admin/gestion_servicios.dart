import 'package:flutter/material.dart';

class GestionServicios extends StatelessWidget {
  final List<Map<String, String>> servicios = [
    {
      "cliente": "cliente@prodegua.com",
      "tipo": "Eléctrico",
      "estado": "Pendiente"
    },
    {
      "cliente": "cliente2@prodegua.com",
      "tipo": "Hidráulico",
      "estado": "En proceso"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestión de Servicios")),
      body: ListView.builder(
        itemCount: servicios.length,
        itemBuilder: (context, index) {
          final servicio = servicios[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Cliente: ${servicio['cliente']}"),
              subtitle: Text(
                  "Tipo: ${servicio['tipo']} - Estado: ${servicio['estado']}"),
              trailing: Icon(Icons.manage_accounts),
            ),
          );
        },
      ),
    );
  }
}
