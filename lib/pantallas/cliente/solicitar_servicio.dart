import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class SolicitarServicio extends StatefulWidget {
  final String? correoCliente; // ahora opcional

  const SolicitarServicio({super.key, this.correoCliente});

  @override
  State<SolicitarServicio> createState() => _SolicitarServicioState();
}

class _SolicitarServicioState extends State<SolicitarServicio> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _guardando = false;

  Future<void> _guardarSolicitud() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final correoCliente = widget.correoCliente ?? "cliente@demo.com";

    try {
      await BaseDatos.insertarServicio(
        _nombreController.text,
        _descripcionController.text,
        "pendiente",
        correoCliente,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Solicitud enviada con éxito")),
      );

      _nombreController.clear();
      _descripcionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al guardar solicitud: $e")),
      );
    } finally {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitar servicio"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Detalles del servicio",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre del servicio",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: "Descripción del servicio",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? "Ingrese una descripción" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: _guardando
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                    : const Text("Enviar solicitud"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: _guardando ? null : _guardarSolicitud,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
