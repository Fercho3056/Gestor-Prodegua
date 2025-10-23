import 'package:flutter/material.dart';
import 'package:proyecto_prodegua/servicios/base_datos.dart';

class ReportarProblema extends StatefulWidget {
  final String correoCliente;
  const ReportarProblema({Key? key, required this.correoCliente})
      : super(key: key);

  @override
  State<ReportarProblema> createState() => _ReportarProblemaState();
}

class _ReportarProblemaState extends State<ReportarProblema> {
  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  Future<void> _reportar() async {
    if (_tituloCtrl.text.isEmpty || _descripcionCtrl.text.isEmpty) return;

    await BaseDatos.insertarServicio(
      _tituloCtrl.text,
      _descripcionCtrl.text,
      'reportado',
      widget.correoCliente,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Problema reportado con éxito")),
    );

    _tituloCtrl.clear();
    _descripcionCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reportar un problema")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloCtrl,
              decoration:
                  const InputDecoration(labelText: "Título del problema"),
            ),
            TextField(
              controller: _descripcionCtrl,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: "Descripción detallada"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reportar,
              child: const Text("Enviar reporte"),
            ),
          ],
        ),
      ),
    );
  }
}
