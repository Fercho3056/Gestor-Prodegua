import 'package:flutter/material.dart';
import '../../servicios/autenticacion_servicio.dart';

class LoginPantalla extends StatefulWidget {
  const LoginPantalla({Key? key}) : super(key: key);

  @override
  State<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends State<LoginPantalla> {
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _auth = AutenticacionServicio();
  bool _cargando = false;

  void _login() async {
    setState(() => _cargando = true);

    final user = await _auth.iniciarSesion(
      _correoController.text.trim(),
      _contrasenaController.text.trim(),
    );

    setState(() => _cargando = false);

    if (user != null) {
      final rol = user['rol'];

      if (rol == 'admin') {
        Navigator.pushReplacementNamed(context, '/panel-admin');
      } else if (rol == 'tecnico') {
        Navigator.pushReplacementNamed(context, '/perfil-tecnico');
      } else {
        Navigator.pushReplacementNamed(context, '/perfil-cliente');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Credenciales inválidas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.water_drop,
                      color: Colors.blueAccent, size: 80),
                  const SizedBox(height: 10),
                  const Text(
                    "Prodegua - Iniciar Sesión",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _correoController,
                    decoration: const InputDecoration(
                      labelText: "Correo electrónico",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _contrasenaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _cargando
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.login),
                          label: const Text("Iniciar Sesión"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/registro'),
                    child: const Text(
                      "¿No tienes cuenta? Regístrate aquí",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
