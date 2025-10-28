import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../servicios/base_datos.dart';

class EstadisticasPantalla extends StatefulWidget {
  final String correo;
  final String rol;

  const EstadisticasPantalla({
    super.key,
    required this.correo,
    required this.rol,
  });

  @override
  State<EstadisticasPantalla> createState() => _EstadisticasPantallaState();
}

class _EstadisticasPantallaState extends State<EstadisticasPantalla> {
  int totalServicios = 0;
  int completados = 0;
  int pendientes = 0;
  int asignados = 0;
  int usuarios = 0;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      if (widget.rol == 'cliente') {
        final lista = await BaseDatos.obtenerServicios(cliente: widget.correo);
        setState(() {
          totalServicios = lista.length;
          completados = lista.where((s) => s['estado'] == 'completado').length;
          pendientes = lista.where((s) => s['estado'] == 'pendiente').length;
          cargando = false;
        });
      } else if (widget.rol == 'tecnico') {
        final lista = await BaseDatos.obtenerServicios(tecnico: widget.correo);
        setState(() {
          totalServicios = lista.length;
          asignados = lista.where((s) => s['estado'] == 'asignado').length;
          completados = lista.where((s) => s['estado'] == 'completado').length;
          cargando = false;
        });
      } else if (widget.rol == 'admin') {
        final servicios = await BaseDatos.obtenerServicios();
        final listaUsuarios = await BaseDatos.obtenerTodosUsuarios();
        setState(() {
          totalServicios = servicios.length;
          completados =
              servicios.where((s) => s['estado'] == 'completado').length;
          pendientes =
              servicios.where((s) => s['estado'] == 'pendiente').length;
          usuarios = listaUsuarios.length;
          cargando = false;
        });
      }
    } catch (e) {
      print("❌ Error al cargar estadísticas: $e");
      setState(() => cargando = false);
    }
  }

  List<PieChartSectionData> _crearDatosGrafico() {
    final estilo = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    if (widget.rol == 'cliente') {
      return [
        PieChartSectionData(
          color: Colors.green.shade400,
          value: completados.toDouble(),
          title: 'Completados',
          radius: 60,
          titleStyle: estilo,
        ),
        PieChartSectionData(
          color: Colors.orangeAccent,
          value: pendientes.toDouble(),
          title: 'Pendientes',
          radius: 60,
          titleStyle: estilo,
        ),
      ];
    } else if (widget.rol == 'tecnico') {
      return [
        PieChartSectionData(
          color: Colors.blueAccent,
          value: asignados.toDouble(),
          title: 'Asignados',
          radius: 60,
          titleStyle: estilo,
        ),
        PieChartSectionData(
          color: Colors.green.shade400,
          value: completados.toDouble(),
          title: 'Completados',
          radius: 60,
          titleStyle: estilo,
        ),
      ];
    } else {
      return [
        PieChartSectionData(
          color: Colors.green.shade400,
          value: completados.toDouble(),
          title: 'Completados',
          radius: 60,
          titleStyle: estilo,
        ),
        PieChartSectionData(
          color: Colors.redAccent,
          value: pendientes.toDouble(),
          title: 'Pendientes',
          radius: 60,
          titleStyle: estilo,
        ),
        PieChartSectionData(
          color: Colors.blueAccent,
          value: usuarios.toDouble(),
          title: 'Usuarios',
          radius: 60,
          titleStyle: estilo,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FB),
      appBar: AppBar(
        title: const Text('📊 Estadísticas'),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
        shadowColor: Colors.black26,
      ),
      body: RefreshIndicator(
        onRefresh: _cargarDatos,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      widget.rol == 'cliente'
                          ? "Resumen de tus servicios"
                          : widget.rol == 'tecnico'
                              ? "Resumen de tus tareas"
                              : "Resumen general del sistema",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          sections: _crearDatosGrafico(),
                          centerSpaceRadius: 45,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 📦 Tarjeta de resumen numérico
              Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "📈 Resumen Detallado",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _filaInfo(
                          "Total de servicios", totalServicios.toString()),
                      if (widget.rol == 'cliente' || widget.rol == 'admin')
                        _filaInfo("Pendientes", pendientes.toString()),
                      if (widget.rol == 'tecnico')
                        _filaInfo("Asignados", asignados.toString()),
                      _filaInfo("Completados", completados.toString()),
                      if (widget.rol == 'admin')
                        _filaInfo("Usuarios registrados", usuarios.toString()),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
                label: const Text('Volver'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filaInfo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
