import 'package:flutter/material.dart';
import '../../servicios/base_datos.dart';

class SolicitarServicio extends StatefulWidget {
  const SolicitarServicio({Key? key}) : super(key: key);

  @override
  State<SolicitarServicio> createState() => _SolicitarServicioState();
}

class _SolicitarServicioState extends State<SolicitarServicio> {
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _guardando = false;

  Future<void> _guardarSolicitud() async {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();

    if (nombre.isEmpty || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      await BaseDatos.insertarServicio(nombre, descripcion, "pendiente");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Solicitud enviada correctamente")),
      );

      _nombreController.clear();
      _descripcionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al guardar: $e")),
      );
    } finally {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Solicitar Servicio"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.build, size: 80, color: Colors.blueAccent),
                const SizedBox(height: 20),
                const Text(
                  "Formulario de Solicitud",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Nombre del servicio
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: "Nombre del servicio",
                    prefixIcon: Icon(Icons.text_fields),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Descripción
                TextField(
                  controller: _descripcionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Descripción del problema o solicitud",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // Botón para enviar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _guardando ? null : _guardarSolicitud,
                    icon: _guardando
                        ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                        : const Icon(Icons.send),
                    label: Text(
                      _guardando ? "Enviando..." : "Enviar Solicitud",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
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
