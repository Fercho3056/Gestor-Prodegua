import 'package:flutter/material.dart';

class PerfilTecnico extends StatelessWidget {
  const PerfilTecnico({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel del Técnico")),
      body: const Center(
        child: Text("Aquí el técnico verá los servicios asignados 🧰",
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
