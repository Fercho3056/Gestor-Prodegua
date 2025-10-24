import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class GestionUsuarios extends StatefulWidget {
  @override
  _GestionUsuariosState createState() => _GestionUsuariosState();
}

class _GestionUsuariosState extends State<GestionUsuarios> {
  List<Map<String, dynamic>> usuarios = [];
  final correoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String rol = 'cliente';

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final data = await BaseDatos.obtenerTodosUsuarios();
    setState(() {
      usuarios = data;
    });
  }

  Future<void> agregarUsuario() async {
    if (!correoCtrl.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El correo debe contener @')),
      );
      return;
    }
    await BaseDatos.insertarUsuario(correoCtrl.text, passCtrl.text, rol);
    correoCtrl.clear();
    passCtrl.clear();
    rol = 'cliente';
    await cargarUsuarios();
  }

  Future<void> eliminarUsuario(int id) async {
    await BaseDatos.eliminarUsuario(id);
    await cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestión de Usuarios")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Agregar nuevo usuario",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: correoCtrl,
              decoration: InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: rol,
              items: ['cliente', 'tecnico', 'admin']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => rol = v!),
            ),
            ElevatedButton(
                onPressed: agregarUsuario, child: Text("Agregar Usuario")),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, i) {
                  final u = usuarios[i];
                  return ListTile(
                    title: Text(u['correo']),
                    subtitle: Text("Rol: ${u['rol']}"),
                    trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => eliminarUsuario(u['id'])),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
