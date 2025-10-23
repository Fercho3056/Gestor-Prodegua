import 'package:flutter/material.dart';
import '../../servicios/servicio_servicio.dart';
import '../../servicios/base_datos.dart';

class AsignarTecnicoPantalla extends StatefulWidget {
  const AsignarTecnicoPantalla({Key? key}) : super(key: key);

  @override
  State<AsignarTecnicoPantalla> createState() => _AsignarTecnicoPantallaState();
}

class _AsignarTecnicoPantallaState extends State<AsignarTecnicoPantalla> {
  final ServicioServicio _servicioServicio = ServicioServicio();

  // listas para mostrar
  List<Map<String, dynamic>> _servicios = [];
  List<Map<String, dynamic>> _tecnicos = [];

  bool _cargando = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    // cargamos datos en initState de forma segura
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
      _error = '';
    });

    try {
      // traer todos los servicios
      final servicios = await _servicioServicio.listarServicios();
      // traer todos los usuarios desde la base
      final usuarios = await BaseDatos.obtenerTodosUsuarios();

      // filtrar solo técnicos (asegurar que rol esté en minúsculas)
      final tecnicos = usuarios.where((u) {
        final rol = (u['rol'] ?? '').toString().toLowerCase();
        return rol == 'tecnico';
      }).toList();

      setState(() {
        _servicios = servicios;
        _tecnicos = tecnicos;
      });
    } catch (e, st) {
      debugPrint('Error cargando datos en AsignarTecnicoPantalla: $e\n$st');
      setState(() {
        _error = 'Error al cargar datos: $e';
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  Future<void> _asignar(int id, String correoTecnico) async {
    try {
      await _servicioServicio.asignarTecnico(id, correoTecnico);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Técnico asignado correctamente')));
      await _cargarDatos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al asignar técnico: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar técnico'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child:
                      Text(_error, style: const TextStyle(color: Colors.red)))
              : _servicios.isEmpty
                  ? const Center(child: Text('No hay solicitudes para asignar'))
                  : RefreshIndicator(
                      onRefresh: _cargarDatos,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _servicios.length,
                        itemBuilder: (context, index) {
                          final s = _servicios[index];
                          final tecnicoAsignado =
                              (s['tecnico'] ?? '').toString();
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(s['nombre'] ?? 'Sin nombre'),
                              subtitle: Text(
                                  'Cliente: ${s['cliente'] ?? ''}\n${s['descripcion'] ?? ''}'),
                              trailing: _tecnicos.isEmpty
                                  ? IconButton(
                                      onPressed: null,
                                      icon:
                                          const Icon(Icons.person_add_disabled),
                                    )
                                  : PopupMenuButton<String>(
                                      onSelected: (correo) async {
                                        if (correo.isNotEmpty) {
                                          await _asignar(
                                              s['id'] as int, correo);
                                        }
                                      },
                                      itemBuilder: (_) => _tecnicos.map((t) {
                                        final correo =
                                            (t['correo'] ?? '').toString();
                                        final display = correo +
                                            ((correo == tecnicoAsignado)
                                                ? ' (asignado)'
                                                : '');
                                        return PopupMenuItem<String>(
                                          value: correo,
                                          child: Text(display),
                                        );
                                      }).toList(),
                                      child: const Icon(Icons.person_add),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
