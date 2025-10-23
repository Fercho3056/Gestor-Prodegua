import 'package:flutter/material.dart';
import '../../servicios/autenticacion_servicio.dart';

class RegistroPantalla extends StatefulWidget {
  const RegistroPantalla({super.key});

  @override
  State<RegistroPantalla> createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _auth = AutenticacionServicio();

  void _registrar() async {
    final correo = _correoController.text.trim();
    final contrasena = _contrasenaController.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
      return;
    }

    // 👇 Se registra forzadamente como CLIENTE
    final user = await _auth.registrar(correo, contrasena, rol: "cliente");

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registro exitoso, inicia sesión.")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al registrar usuario")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: "Correo")),
            TextField(
                controller: _contrasenaController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _registrar, child: const Text("Crear cuenta")),
          ],
        ),
      ),
    );
  }
}
