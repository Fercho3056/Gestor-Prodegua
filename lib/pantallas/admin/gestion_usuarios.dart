import 'package:flutter/material.dart';

class GestionUsuarios extends StatelessWidget {
  final List<Map<String, String>> usuarios = [
    {"correo": "cliente@prodegua.com", "rol": "Cliente"},
    {"correo": "tecnico@prodegua.com", "rol": "Técnico"},
    {"correo": "admin@prodegua.com", "rol": "Administrador"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestión de Usuarios")),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return Card(
            child: ListTile(
              title: Text(usuario["correo"]!),
              subtitle: Text("Rol: ${usuario["rol"]}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Usuario eliminado")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
