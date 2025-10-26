import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_prodegua/servicios/base_datos.dart';

class EditarPerfil extends StatefulWidget {
  final String correo;

  const EditarPerfil({super.key, required this.correo});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  String? _rol;
  File? _imagenPerfil;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final usuario = await BaseDatos.obtenerUsuarioPorCorreo(widget.correo);
    if (usuario != null) {
      setState(() {
        _correoCtrl.text = usuario['correo'] ?? '';
        _passCtrl.text = usuario['contrasena'] ?? '';
        _rol = usuario['rol'] ?? 'cliente';
      });
    }
  }

  Future<void> _guardarCambios() async {
    setState(() => _guardando = true);

    try {
      final usuario = await BaseDatos.obtenerUsuarioPorCorreo(widget.correo);
      if (usuario == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario no encontrado.")),
        );
        return;
      }

      final db = await BaseDatos.database;
      await db.update(
        'usuarios',
        {
          'correo': _correoCtrl.text,
          'contrasena': _passCtrl.text,
          'rol': _rol,
        },
        where: 'id = ?',
        whereArgs: [usuario['id']],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Perfil actualizado correctamente")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al guardar: $e")),
      );
    } finally {
      setState(() => _guardando = false);
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenPerfil = File(imagen.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _guardando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 🧑‍💼 Imagen de perfil
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _imagenPerfil != null
                            ? FileImage(_imagenPerfil!)
                            : const AssetImage('assets/avatar.png')
                                as ImageProvider,
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 28),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.blueAccent),
                          shape: WidgetStateProperty.all(const CircleBorder()),
                        ),
                        onPressed: _seleccionarImagen,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 📧 Campo correo
                  TextField(
                    controller: _correoCtrl,
                    decoration: const InputDecoration(
                      labelText: "Correo electrónico",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🔒 Contraseña
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🎭 Rol (solo lectura)
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Rol de usuario',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    child: Text(_rol ?? 'cliente'),
                  ),

                  const SizedBox(height: 30),

                  // 💾 Botón guardar
                  ElevatedButton.icon(
                    onPressed: _guardarCambios,
                    icon: const Icon(Icons.save_alt),
                    label: const Text("Guardar Cambios"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
