import 'package:flutter/material.dart';
import 'package:proyecto_prodegua/servicios/base_datos.dart';

class EditarPerfil extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const EditarPerfil({Key? key, required this.usuario}) : super(key: key);

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _correoCtrl.text = widget.usuario['correo'];
    _contrasenaCtrl.text = widget.usuario['contrasena'];
  }

  Future<void> _guardarCambios() async {
    final db = await BaseDatos.database;
    await db.update(
      'usuarios',
      {
        'correo': _correoCtrl.text,
        'contrasena': _contrasenaCtrl.text,
      },
      where: 'id = ?',
      whereArgs: [widget.usuario['id']],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Cambios guardados exitosamente")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _correoCtrl,
              decoration:
                  const InputDecoration(labelText: "Correo electrónico"),
            ),
            TextField(
              controller: _contrasenaCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
