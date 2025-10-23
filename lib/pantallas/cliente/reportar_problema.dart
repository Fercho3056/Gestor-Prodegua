// lib/pantallas/cliente/reportar_problema.dart
import 'package:flutter/material.dart';
import '../../servicios/servicio_servicio.dart';
import '../../servicios/autenticacion_servicio.dart';

class ReportarProblemaPantalla extends StatefulWidget {
  const ReportarProblemaPantalla({Key? key}) : super(key: key);

  @override
  State<ReportarProblemaPantalla> createState() =>
      _ReportarProblemaPantallaState();
}

class _ReportarProblemaPantallaState extends State<ReportarProblemaPantalla> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final ServicioServicio _servicioServicio = ServicioServicio();
  final AutenticacionServicio _auth = AutenticacionServicio();
  bool _guardando = false;

  Future<void> _enviar() async {
    final t = _tituloController.text.trim();
    final d = _descripcionController.text.trim();

    if (t.isEmpty || d.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa todos los campos')));
      return;
    }

    final usuario = _auth.usuarioActual;
    final correoCliente = usuario != null ? usuario['correo'] as String? : null;

    if (correoCliente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay usuario logueado')));
      return;
    }

    setState(() => _guardando = true);
    try {
      await _servicioServicio.crearSolicitud(t, d, correoCliente);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud registrada ✅')));
      _tituloController.clear();
      _descripcionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar problema / Solicitar servicio'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.report_problem,
                    size: 72, color: Colors.blueAccent),
                const SizedBox(height: 12),
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                      labelText: 'Título del servicio',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descripcionController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      labelText: 'Descripción', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _guardando ? null : _enviar,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: _guardando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Enviar solicitud'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
